local charactersPath = Config.charactersPath

local playersLicenses = {}

function LoadData(path, file)
	local loadFile= LoadResourceFile(GetCurrentResourceName(), path..file)
	extract = json.decode(loadFile)

	return extract
end

function SaveData(path, file, data)
	SaveResourceFile(GetCurrentResourceName(), path..file, json.encode(data), -1)
end

function NewDefaultPlayer()
	local data = {}

	for _, stat in pairs(Config.playerData) do 
		data[stat.name] = stat.default
	end

	return data
end


RegisterNetEvent("save-load:saveCharacterServer")
AddEventHandler("save-load:saveCharacterServer", function(source, data)
	local license = GetPlayerLicense(source)

	playersLicenses[source] = license
	SaveData(charactersPath, playersLicenses[source]..".json", data)
end)

RegisterNetEvent("save-load:playerSpawned")
AddEventHandler('save-load:playerSpawned', function(source)
	local license = GetPlayerLicense(source)

	playersLicenses[source] = license

	--TriggerClientEvent("save-load:saveCharacterClient", source)
	local characterData = LoadData(charactersPath, playersLicenses[source]..".json")
	if not characterData then 
		characterData = NewDefaultPlayer()

		SaveData(charactersPath, playersLicenses[source]..".json", characterData)
		
		TriggerClientEvent("save-load:loadNewPlayer", source, characterData)
	else
		TriggerClientEvent("save-load:loadPlayer", source, characterData)
	end
end)

function GetPlayerLicense(source)
	local license = nil
	for k, v in pairs(GetPlayerIdentifiers(source)) do
		if string.sub(v, 1, string.len("license:")) == "license:" then
			license = string.sub(v, string.len("license:") + 1, string.len(v))
		end
	end

	return license
end




