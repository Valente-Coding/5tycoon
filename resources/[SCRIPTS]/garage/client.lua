local spawnedVehs = {}

function GetVehicleBodyDamage(veh)
    local vehicleBodyDamage = {}

    vehicleBodyDamage["tyres"] = {}
    vehicleBodyDamage["windows"] = {}
    vehicleBodyDamage["doors"] = {}

    for id = 1, 7 do
        local tyreId = IsVehicleTyreBurst(veh, id, false)
    
        if tyreId then
            vehicleBodyDamage["tyres"][#vehicleBodyDamage["tyres"] + 1] = tyreId
    
            if tyreId == false then
                tyreId = IsVehicleTyreBurst(veh, id, true)
                vehicleBodyDamage["tyres"][ #vehicleBodyDamage["tyres"]] = tyreId
            end
        else
            vehicleBodyDamage["tyres"][#vehicleBodyDamage["tyres"] + 1] = false
        end
    end

    for id = 1, 13 do
        local windowId = IsVehicleWindowIntact(veh, id)

        if windowId ~= nil then
            vehicleBodyDamage["windows"][#vehicleBodyDamage["windows"] + 1] = windowId
        else
            vehicleBodyDamage["windows"][#vehicleBodyDamage["windows"] + 1] = true
        end
    end
    
    for id = 0, 5 do
        local doorId = IsVehicleDoorDamaged(veh, id)
    
        if doorId then
            vehicleBodyDamage["doors"][#vehicleBodyDamage["doors"] + 1] = doorId
        else
            vehicleBodyDamage["doors"][#vehicleBodyDamage["doors"] + 1] = false
        end
    end

    

    return vehicleBodyDamage
end

function GetVehData(veh)
    local data = {}

    data["bodydeformation"] = exports["VehicleDeformation"]:GetVehicleDeformation(veh)
    data["model"] = GetEntityModel(veh)
    data["lastpos"] = GetEntityCoords(veh)
    data["lastheading"] = GetEntityHeading(veh)
    data["enginehealth"] = GetVehicleEngineHealth(veh)
    data["fuelLevel"] = GetVehicleFuelLevel(veh)
    data["bodydamage"] = GetVehicleBodyDamage(veh)
    data["lockedstatus"] = GetVehicleDoorLockStatus(veh)
    data["plate"] = GetVehicleNumberPlateText(veh)
    data["properties"] = GetVehicleProperties(veh)

    return data
end

function SetVehicleBodyDamage(veh, vehicleBodyDamage)
    
    if vehicleBodyDamage["windows"] then
        for i = 0, 13, 1 do
            FixVehicleWindow(veh, i)
        end 
        for windowId = 1, 13, 1 do
            
            if vehicleBodyDamage["windows"][windowId] == false then
                SmashVehicleWindow(veh, windowId)
            end
        end
    end

    if vehicleBodyDamage["tyres"] then
        for tyreId = 1, 7, 1 do
            if vehicleBodyDamage["tyres"][tyreId] ~= false then
                SetVehicleTyreBurst(veh, tyreId, true, 1000)
            end
        end
    end

    if vehicleBodyDamage["doors"] then
        for doorId = 0, 5, 1 do
            if vehicleBodyDamage["doors"][doorId] ~= false then
                SetVehicleDoorBroken(veh, doorId - 1, true)
            end
        end
    end
end

function SetVehData(veh, data) 
    exports["VehicleDeformation"]:SetVehicleDeformation(veh, data["bodydeformation"])
    SetVehicleEngineHealth(veh, data["enginehealth"])
    SetVehicleFuelLevel(veh, data["fuelLevel"])
    SetVehicleBodyDamage(veh, data["bodydamage"])
    SetVehicleDoorsLocked(veh, data["lockedstatus"])
    SetVehicleProperties(veh, data["properties"])
end

RegisterNetEvent("garage:addVehicleToChar")

function AddVehicleToChar(veh)
    local vehData = GetVehData(veh)
    local charVehs = json.decode(GetExternalKvpString("save-load", "CHAR_VEHICLES"))

    table.insert(charVehs, vehData)
    TriggerEvent("save-load:setGlobalVariables", {{name = "CHAR_VEHICLES", type = "string", value = json.encode(charVehs)}})
end

AddEventHandler("garage:addVehicleToChar", AddVehicleToChar)


function SpawnVehicle(data)
    local veh = CreateVehicle(data["model"], data["lastpos"].x, data["lastpos"].y, data["lastpos"].z, data["lastheading"], true, true)
	if veh then 
		blip = AddBlipForEntity(veh)
		SetBlipSprite(blip, 225)
        SetBlipScale(blip, 0.7)
        SetBlipColour(blip, 0)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Owned Vehicle")
        EndTextCommandSetBlipName(blip)

    	SetVehData(veh, data)
		table.insert(spawnedVehs, veh)
    	TriggerEvent("save-load:setGlobalVariables", {{name = "CHAR_SPAWNED_VEHICLES", type = "string", value = json.encode(spawnedVehs)}})
	end
end

function SaveVehicle(veh)
    local charVehs = json.decode(GetExternalKvpString("save-load", "CHAR_VEHICLES"))

    for i, charVeh in pairs(charVehs) do
        if charVeh["plate"] == GetVehicleNumberPlateText(veh) then 
            charVehs[i] = GetVehData(veh)
            TriggerEvent("save-load:setGlobalVariables", {{name = "CHAR_VEHICLES", type = "string", value = json.encode(charVehs)}})
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
        if IsPedInAnyVehicle(ped) then 
			local veh = GetVehiclePedIsIn(ped)
            SaveVehicle(veh)
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

function SetVehicleProperties(vehicle, props)
    SetVehicleModKit(vehicle, 0)

	if props.plate ~= nil then
		SetVehicleNumberPlateText(vehicle, props.plate)
	end

	if props.plateIndex ~= nil then
		SetVehicleNumberPlateTextIndex(vehicle, props.plateIndex)
	end

	if props.health ~= nil then
		SetEntityHealth(vehicle, props.health)
	end

	if props.dirtLevel ~= nil then
		SetVehicleDirtLevel(vehicle, props.dirtLevel)
	end

	if props.color1 ~= nil then
		local color1, color2 = GetVehicleColours(vehicle)
		SetVehicleColours(vehicle, props.color1, color2)
	end

	if props.color2 ~= nil then
		local color1, color2 = GetVehicleColours(vehicle)
		SetVehicleColours(vehicle, color1, props.color2)
	end

	if props.pearlescentColor ~= nil then
		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
		SetVehicleExtraColours(vehicle, props.pearlescentColor, wheelColor)
	end

	if props.wheelColor ~= nil then
		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
		SetVehicleExtraColours(vehicle, pearlescentColor, props.wheelColor)
	end

	if props.wheels ~= nil then
		SetVehicleWheelType(vehicle, props.wheels)
	end

	if props.windowTint ~= nil then
		SetVehicleWindowTint(vehicle, props.windowTint)
	end

	if props.neonEnabled ~= nil then
		SetVehicleNeonLightEnabled(vehicle, 0, props.neonEnabled[1])
		SetVehicleNeonLightEnabled(vehicle, 1, props.neonEnabled[2])
		SetVehicleNeonLightEnabled(vehicle, 2, props.neonEnabled[3])
		SetVehicleNeonLightEnabled(vehicle, 3, props.neonEnabled[4])
	end

	if props.extras ~= nil then
		for id,enabled in pairs(props.extras) do
			if enabled then
				SetVehicleExtra(vehicle, tonumber(id), 0)
			else
				SetVehicleExtra(vehicle, tonumber(id), 1)
			end
		end
	end

	if props.neonColor ~= nil then
		SetVehicleNeonLightsColour(vehicle, props.neonColor[1], props.neonColor[2], props.neonColor[3])
	end

	if props.modSmokeEnabled ~= nil then
		ToggleVehicleMod(vehicle, 20, true)
	end

	if props.tyreSmokeColor ~= nil then
		SetVehicleTyreSmokeColor(vehicle, props.tyreSmokeColor[1], props.tyreSmokeColor[2], props.tyreSmokeColor[3])
	end

	if props.modSpoilers ~= nil then
		SetVehicleMod(vehicle, 0, props.modSpoilers, false)
	end

	if props.modFrontBumper ~= nil then
		SetVehicleMod(vehicle, 1, props.modFrontBumper, false)
	end

	if props.modRearBumper ~= nil then
		SetVehicleMod(vehicle, 2, props.modRearBumper, false)
	end

	if props.modSideSkirt ~= nil then
		SetVehicleMod(vehicle, 3, props.modSideSkirt, false)
	end

	if props.modExhaust ~= nil then
		SetVehicleMod(vehicle, 4, props.modExhaust, false)
	end

	if props.modFrame ~= nil then
		SetVehicleMod(vehicle, 5, props.modFrame, false)
	end

	if props.modGrille ~= nil then
		SetVehicleMod(vehicle, 6, props.modGrille, false)
	end

	if props.modHood ~= nil then
		SetVehicleMod(vehicle, 7, props.modHood, false)
	end

	if props.modFender ~= nil then
		SetVehicleMod(vehicle, 8, props.modFender, false)
	end

	if props.modRightFender ~= nil then
		SetVehicleMod(vehicle, 9, props.modRightFender, false)
	end

	if props.modRoof ~= nil then
		SetVehicleMod(vehicle, 10, props.modRoof, false)
	end

	if props.modEngine ~= nil then
		SetVehicleMod(vehicle, 11, props.modEngine, false)
	end

	if props.modBrakes ~= nil then
		SetVehicleMod(vehicle, 12, props.modBrakes, false)
	end

	if props.modTransmission ~= nil then
		SetVehicleMod(vehicle, 13, props.modTransmission, false)
	end

	if props.modHorns ~= nil then
		SetVehicleMod(vehicle, 14, props.modHorns, false)
	end

	if props.modSuspension ~= nil then
		SetVehicleMod(vehicle, 15, props.modSuspension, false)
	end

	if props.modArmor ~= nil then
		SetVehicleMod(vehicle, 16, props.modArmor, false)
	end

	if props.modTurbo ~= nil then
		ToggleVehicleMod(vehicle,  18, props.modTurbo)
	end

	if props.modXenon ~= nil then
		ToggleVehicleMod(vehicle,  22, props.modXenon)
	end

	if props.modFrontWheels ~= nil then
		SetVehicleMod(vehicle, 23, props.modFrontWheels, false)
	end

	if props.modBackWheels ~= nil then
		SetVehicleMod(vehicle, 24, props.modBackWheels, false)
	end

	if props.modPlateHolder ~= nil then
		SetVehicleMod(vehicle, 25, props.modPlateHolder, false)
	end

	if props.modVanityPlate ~= nil then
		SetVehicleMod(vehicle, 26, props.modVanityPlate, false)
	end

	if props.modTrimA ~= nil then
		SetVehicleMod(vehicle, 27, props.modTrimA, false)
	end

	if props.modOrnaments ~= nil then
		SetVehicleMod(vehicle, 28, props.modOrnaments, false)
	end

	if props.modDashboard ~= nil then
		SetVehicleMod(vehicle, 29, props.modDashboard, false)
	end

	if props.modDial ~= nil then
		SetVehicleMod(vehicle, 30, props.modDial, false)
	end

	if props.modDoorSpeaker ~= nil then
		SetVehicleMod(vehicle, 31, props.modDoorSpeaker, false)
	end

	if props.modSeats ~= nil then
		SetVehicleMod(vehicle, 32, props.modSeats, false)
	end

	if props.modSteeringWheel ~= nil then
		SetVehicleMod(vehicle, 33, props.modSteeringWheel, false)
	end

	if props.modShifterLeavers ~= nil then
		SetVehicleMod(vehicle, 34, props.modShifterLeavers, false)
	end

	if props.modAPlate ~= nil then
		SetVehicleMod(vehicle, 35, props.modAPlate, false)
	end

	if props.modSpeakers ~= nil then
		SetVehicleMod(vehicle, 36, props.modSpeakers, false)
	end

	if props.modTrunk ~= nil then
		SetVehicleMod(vehicle, 37, props.modTrunk, false)
	end

	if props.modHydrolic ~= nil then
		SetVehicleMod(vehicle, 38, props.modHydrolic, false)
	end

	if props.modEngineBlock ~= nil then
		SetVehicleMod(vehicle, 39, props.modEngineBlock, false)
	end

	if props.modAirFilter ~= nil then
		SetVehicleMod(vehicle, 40, props.modAirFilter, false)
	end

	if props.modStruts ~= nil then
		SetVehicleMod(vehicle, 41, props.modStruts, false)
	end

	if props.modArchCover ~= nil then
		SetVehicleMod(vehicle, 42, props.modArchCover, false)
	end

	if props.modAerials ~= nil then
		SetVehicleMod(vehicle, 43, props.modAerials, false)
	end

	if props.modTrimB ~= nil then
		SetVehicleMod(vehicle, 44, props.modTrimB, false)
	end

	if props.modTank ~= nil then
		SetVehicleMod(vehicle, 45, props.modTank, false)
	end

	if props.modWindows ~= nil then
		SetVehicleMod(vehicle, 46, props.modWindows, false)
	end

	if props.modLivery ~= nil then
		SetVehicleMod(vehicle, 48, props.modLivery, false)
		SetVehicleLivery(vehicle, props.modLivery)
	end
end

function GetVehicleProperties(vehicle)
    local color1, color2 = GetVehicleColours(vehicle)
	local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
	local extras = {}

	for id=0, 12 do
		if DoesExtraExist(vehicle, id) then
			local state = IsVehicleExtraTurnedOn(vehicle, id) == 1
			extras[tostring(id)] = state
		end
	end

	return {

		model             = GetEntityModel(vehicle),

		plate             = GetVehicleNumberPlateText(vehicle),
		plateIndex        = GetVehicleNumberPlateTextIndex(vehicle),

		health            = GetEntityHealth(vehicle),
		dirtLevel         = GetVehicleDirtLevel(vehicle),

		color1            = color1,
		color2            = color2,

		pearlescentColor  = pearlescentColor,
		wheelColor        = wheelColor,

		wheels            = GetVehicleWheelType(vehicle),
		windowTint        = GetVehicleWindowTint(vehicle),

		neonEnabled       = {
			IsVehicleNeonLightEnabled(vehicle, 0),
			IsVehicleNeonLightEnabled(vehicle, 1),
			IsVehicleNeonLightEnabled(vehicle, 2),
			IsVehicleNeonLightEnabled(vehicle, 3)
		},

		extras            = extras,

		neonColor         = table.pack(GetVehicleNeonLightsColour(vehicle)),
		tyreSmokeColor    = table.pack(GetVehicleTyreSmokeColor(vehicle)),

		modSpoilers       = GetVehicleMod(vehicle, 0),
		modFrontBumper    = GetVehicleMod(vehicle, 1),
		modRearBumper     = GetVehicleMod(vehicle, 2),
		modSideSkirt      = GetVehicleMod(vehicle, 3),
		modExhaust        = GetVehicleMod(vehicle, 4),
		modFrame          = GetVehicleMod(vehicle, 5),
		modGrille         = GetVehicleMod(vehicle, 6),
		modHood           = GetVehicleMod(vehicle, 7),
		modFender         = GetVehicleMod(vehicle, 8),
		modRightFender    = GetVehicleMod(vehicle, 9),
		modRoof           = GetVehicleMod(vehicle, 10),

		modEngine         = GetVehicleMod(vehicle, 11),
		modBrakes         = GetVehicleMod(vehicle, 12),
		modTransmission   = GetVehicleMod(vehicle, 13),
		modHorns          = GetVehicleMod(vehicle, 14),
		modSuspension     = GetVehicleMod(vehicle, 15),
		modArmor          = GetVehicleMod(vehicle, 16),

		modTurbo          = IsToggleModOn(vehicle, 18),
		modSmokeEnabled   = IsToggleModOn(vehicle, 20),
		modXenon          = IsToggleModOn(vehicle, 22),

		modFrontWheels    = GetVehicleMod(vehicle, 23),
		modBackWheels     = GetVehicleMod(vehicle, 24),

		modPlateHolder    = GetVehicleMod(vehicle, 25),
		modVanityPlate    = GetVehicleMod(vehicle, 26),
		modTrimA          = GetVehicleMod(vehicle, 27),
		modOrnaments      = GetVehicleMod(vehicle, 28),
		modDashboard      = GetVehicleMod(vehicle, 29),
		modDial           = GetVehicleMod(vehicle, 30),
		modDoorSpeaker    = GetVehicleMod(vehicle, 31),
		modSeats          = GetVehicleMod(vehicle, 32),
		modSteeringWheel  = GetVehicleMod(vehicle, 33),
		modShifterLeavers = GetVehicleMod(vehicle, 34),
		modAPlate         = GetVehicleMod(vehicle, 35),
		modSpeakers       = GetVehicleMod(vehicle, 36),
		modTrunk          = GetVehicleMod(vehicle, 37),
		modHydrolic       = GetVehicleMod(vehicle, 38),
		modEngineBlock    = GetVehicleMod(vehicle, 39),
		modAirFilter      = GetVehicleMod(vehicle, 40),
		modStruts         = GetVehicleMod(vehicle, 41),
		modArchCover      = GetVehicleMod(vehicle, 42),
		modAerials        = GetVehicleMod(vehicle, 43),
		modTrimB          = GetVehicleMod(vehicle, 44),
		modTank           = GetVehicleMod(vehicle, 45),
		modWindows        = GetVehicleMod(vehicle, 46),
		modLivery         = GetVehicleLivery(vehicle)
	}
end