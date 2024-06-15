local spawnedVehs = {}

RegisterNetEvent("garage:addVehicleToChar")

function AddVehicleToChar(veh)
	TriggerEvent("vehicle-stats:getProperties", veh, function(properties)
		local charVehs = json.decode(GetExternalKvpString("save-load", "CHAR_VEHICLES"))

		AddBlipToVeh(veh)

		table.insert(charVehs, {lastpos = GetEntityCoords(veh), lastheading = GetEntityHeading(veh), properties = properties})
		table.insert(spawnedVehs, veh)
		TriggerEvent("save-load:setGlobalVariables", {{name = "CHAR_VEHICLES", type = "string", value = json.encode(charVehs)}, {name = "CHAR_SPAWNED_VEHICLES", type = "string", value = json.encode(spawnedVehs)}})
	end)
end

AddEventHandler("garage:addVehicleToChar", AddVehicleToChar)

RegisterNetEvent("multichar:charDied")

function DeleteSpawnedVehicles()
	local vehs = json.decode(GetExternalKvpString("save-load", "CHAR_SPAWNED_VEHICLES"))

	for _, veh in pairs(vehs) do 
		DeleteEntity(veh)
	end
end

AddEventHandler("multichar:charDied", DeleteSpawnedVehicles)

function SpawnVehicle(data)
    local veh = CreateVehicle(data.properties.model, data.lastpos.x, data.lastpos.y, data.lastpos.z, data.lastheading, true, true)
	if veh then 
		AddBlipToVeh(veh)

    	TriggerEvent("vehicle-stats:setProperties", veh, data)
		table.insert(spawnedVehs, veh)
    	TriggerEvent("save-load:setGlobalVariables", {{name = "CHAR_SPAWNED_VEHICLES", type = "string", value = json.encode(spawnedVehs)}})
	end
end

function AddBlipToVeh(veh)
	if veh then 
        TriggerEvent("waypointer:add", 
            "vehicle-"..GetVehicleNumberPlateText(veh), --waypointer name
            {
                coords = nil, 
                entity = veh, -- No need to set coords when using entities
                sprite = 225, scale = 0.7, 
                short = true, 
                color = 26, 
                label = "Owned Vehicle"
            }, 
            {
                coords = nil, 
                color = 26, 
                onFoot = true, 
                radarThick = 16, 
                mapThick = 16, 
                range = 30, 
                removeBlip = true
            }
        )
	end
end

function SaveVehicle(veh)
    local charVehs = json.decode(GetExternalKvpString("save-load", "CHAR_VEHICLES"))

    for i, charVeh in pairs(charVehs) do
        if charVeh.properties.plate == GetVehicleNumberPlateText(veh) then 
			TriggerEvent("vehicle-stats:getProperies", veh, function(properties)
				charVehs[i].properties = properties
                charVehs[i].lastpos = GetEntityCoords(veh)
                charVehs[i].lastheading = GetEntityHeading(veh)

            	TriggerEvent("save-load:setGlobalVariables", {{name = "CHAR_VEHICLES", type = "string", value = json.encode(charVehs)}})
			end)
            
            break
        end
    end
end

local wasInVehicle = false
local lastVehicle = false
Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(2000)
        local ped = GetPlayerPed(-1)
        if IsPedInAnyVehicle(ped) and not wasInVehicle then 
            wasInVehicle = true
            lastVehicle = GetVehiclePedIsIn(ped)
        elseif not IsPedInAnyVehicle(ped) and wasInVehicle then
            wasInVehicle = false
            SaveVehicle(lastVehicle)
        end
    end
end)

RegisterNetEvent("garage:spawnvehicles")
AddEventHandler("garage:spawnvehicles", function()
    local charVehs = json.decode(GetExternalKvpString("save-load", "CHAR_VEHICLES"))

    for _, vehData in pairs(charVehs) do 
        SpawnVehicle(vehData)
    end
end)

--[[ RegisterCommand("yoink", function()
    local ped = GetPlayerPed(-1)
    if IsPedInAnyVehicle(ped) then
        AddVehicleToChar(GetVehiclePedIsIn(ped))
    end
end, false)

RegisterCommand("garage", function(source, args, rawCommand)
    if args[1] then 
        local charVehs = json.decode(GetExternalKvpString("save-load", "CHAR_VEHICLES"))
        SpawnVehicle(charVehs[tonumber(args[1])])
    end
end, false) 

RegisterCommand("setextra", function()
    local ped = GetPlayerPed(-1)
    if IsPedInAnyVehicle(ped) then
        SetVehicleModKit(GetVehiclePedIsIn(ped), 0)
        SetVehicleMod(GetVehiclePedIsIn(ped), 0, 2, false)
    end
end, false)]]
