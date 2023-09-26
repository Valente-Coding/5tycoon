local license = nil
RegisterNetEvent("save-load:sendLicense")
AddEventHandler("save-load:sendLicense", function(value)
	license = value

	SetKpvs({{name = "PLAYER_LICENSE", type = "string", value = license}})
end)


Citizen.CreateThread(function()
	source = GetPlayerServerId(PlayerId())
	TriggerServerEvent("save-load:getLicense", source)
end)


RegisterNetEvent("save-load:createDefaultVariables")

function CreateDefaultVariables()
    for _, kpv in pairs(Config.DefaultVariables) do 
		if kpv.type == "int" then
			SetResourceKvpInt(kpv.name, kpv.default)
		end

		if kpv.type == "string" then
			SetResourceKvp(kpv.name, kpv.default)
		end

		if kpv.type == "float" then
			SetResourceKvpFloat(kpv.name, kpv.default)
		end
	end
end

AddEventHandler("save-load:createDefaultVariables", CreateDefaultVariables)

AddEventHandler("playerSpawned", function(spawn)
	CreateDefaultVariables()
end)



RegisterNetEvent("save-load:setGlobalVariables")

function SetKpvs(kpvs)
	for _, kpv in pairs(kpvs) do 
		if kpv.type == "int" then
			SetResourceKvpInt(kpv.name, kpv.value)
		end

		if kpv.type == "string" then
			SetResourceKvp(kpv.name, kpv.value)
		end

		if kpv.type == "float" then
			SetResourceKvpFloat(kpv.name, kpv.value)
		end
	end
end

AddEventHandler("save-load:setGlobalVariables", SetKpvs)



RegisterNetEvent("save-load:getGlobalVariables")

function GetKpvs(kpvs, cb)
	local data = {}

	for _, kpv in pairs(kpvs) do 
		if kpv.type == "int" then
			data[kpv.name] = GetResourceKvpInt(kpv.name)
		end

		if kpv.type == "string" then
			data[kpv.name] = GetResourceKvpString(kpv.name)
		end

		if kpv.type == "float" then
			data[kpv.name] = GetResourceKvpFloat(kpv.name)
		end
	end

	if cb then 
		cb(data)
	end
end

AddEventHandler("save-load:getGlobalVariables", GetKpvs)


RegisterNetEvent("save-load:getDefaultVariables")

function GetDefaultKpvs(cb)
	local data = {}

	for _, kpv in pairs(Config.DefaultVariables) do 
		if kpv.type == "int" then
			data[kpv.name] = GetResourceKvpInt(kpv.name)
		end

		if kpv.type == "string" then
			data[kpv.name] = GetResourceKvpString(kpv.name)
		end

		if kpv.type == "float" then
			data[kpv.name] = GetResourceKvpFloat(kpv.name)
		end
	end

	if cb then 
		cb(data)
	end
end

AddEventHandler("save-load:getDefaultVariables", GetDefaultKpvs)


Citizen.CreateThread(function()
	while true do 
		local ped = GetPlayerPed(-1)
		local coords = GetEntityCoords(ped)
		SetKpvs({{name = "LAST_LOCATION", type = "string", value = json.encode({x = coords.x, y = coords.y, z = coords.z})}})
		Citizen.Wait(1500)
	end
end)