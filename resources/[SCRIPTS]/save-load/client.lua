local source = GetPlayerServerId(PlayerId())

RegisterNetEvent("save-load:loadPlayer")


function LoadCharacter(data) 
	if data["CHAR_APPEREANCE"] then 
		exports['fivem-appearance']:setPlayerAppearance(json.decode(data["CHAR_APPEREANCE"]))
	end

	for _, stat in pairs(Config.playerData) do 
		if stat.type == "int" then
			SetResourceKvpInt(stat.name, data[stat.name])
		end

		if stat.type == "string" then
			SetResourceKvp(stat.name, data[stat.name])
		end

		if stat.type == "float" then
			SetResourceKvpFloat(stat.name, data[stat.name])
		end
	end
end 


AddEventHandler("save-load:loadPlayer", function(data)
	LoadCharacter(data)
end)

RegisterNetEvent("save-load:loadNewPlayer")


function LoadNewCharacter(data) 
	for _, stat in pairs(Config.playerData) do 
		if stat.type == "int" then
			SetResourceKvpInt(stat.name, data[stat.name])
		end

		if stat.type == "string" then
			SetResourceKvp(stat.name, data[stat.name])
		end

		if stat.type == "float" then
			SetResourceKvpFloat(stat.name, data[stat.name])
		end
	end

	SaveCharacter() 
end 


AddEventHandler("save-load:loadNewPlayer", function(data)
	local config = {
		ped = true,
		headBlend = true,
		faceFeatures = true,
		headOverlays = true,
		components = true,
		props = true,
		allowExit = true,
		tattoos = true
	  }
	
	exports['fivem-appearance']:startPlayerCustomization(function (appearance)
		if (appearance) then
			data["CHAR_APPEREANCE"] = json.encode(appearance)

			LoadNewCharacter(data)
		end
	end, config)
end)


RegisterNetEvent("save-load:updateData")


function UpdateData(data) 
	for _, stat in pairs(data) do 
		if stat.type == "int" then
			SetResourceKvpInt(stat.name, stat.value)
		end

		if stat.type == "string" then
			SetResourceKvp(stat.name, stat.value)
		end

		if stat.type == "float" then
			SetResourceKvpFloat(stat.name, stat.value)
		end

		if stat.id == "DIRTY_BALANCE" and stat.value ~= 0 then 
			SetResourceKvp("DIRTY_DISPLAY", 1)
		end
	end

	SaveCharacter()
end


AddEventHandler("save-load:updateData", function(data)
	UpdateData(data)
end)

RegisterNetEvent("save-load:saveCharacterClient")


function SaveCharacter() 
	local data = {}

	for _, stat in pairs(Config.playerData) do 
		if stat.type == "int" then
			data[stat.name] = GetResourceKvpInt(stat.name)
		end

		if stat.type == "string" then
			data[stat.name] = GetResourceKvpString(stat.name)
		end

		if stat.type == "float" then
			data[stat.name] = GetResourceKvpFloat(stat.name)
		end
	end

	TriggerServerEvent("save-load:saveCharacterServer", source, data)
end


AddEventHandler("save-load:saveCharacterClient", function()
	SaveCharacter()
end)


AddEventHandler("playerSpawned", function(spawn)
	source = GetPlayerServerId(PlayerId())
	TriggerServerEvent("save-load:playerSpawned", source)
end)
