RegisterNetEvent("save-load:loadData")

function LoadData(path, source)
	local loadFile = LoadResourceFile(GetCurrentResourceName(), path)
	extract = json.decode(loadFile)

	TriggerClientEvent("save-load:loadDataResult", source, extract, path)
end

AddEventHandler("save-load:loadData", LoadData)

----------------------||

RegisterNetEvent("save-load:saveData")

function SaveData(path, data)
	SaveResourceFile(GetCurrentResourceName(), path, json.encode(data), -1)
end

AddEventHandler("save-load:saveData", SaveData)

----------------------||

RegisterNetEvent("save-load:getLicense")


function GetPlayerLicense(source)
	local license = nil
	for k, v in pairs(GetPlayerIdentifiers(source)) do
		if string.sub(v, 1, string.len("license:")) == "license:" then
			license = string.sub(v, string.len("license:") + 1, string.len(v))
		end
	end
	
	return license
end

AddEventHandler('save-load:getLicense', function(source)
	TriggerClientEvent("save-load:sendLicense", source, GetPlayerLicense(source))
end)

----------------------||


--[[ RegisterNetEvent("save-load:playerSpawned")
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
end) ]]