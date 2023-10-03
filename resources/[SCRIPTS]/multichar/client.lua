local maxChars = 3
local charsPath = ""
local charSelected = nil
local charLoaded = false
local makingchar = false
local chars = {}

function CharacterData()
    local selectedChar = chars[charSelected]
    if selectedChar then 
        local kpvs = {}
        for key, value in pairs(selectedChar) do 
            local stattype = nil

            if type(value) == "number" then 
                if value == math.floor(value) then 
                    stattype = "int"
                else
                    stattype = "float"
                end
            elseif type(value) == "string" then 
                stattype = "string"
            end

            table.insert(kpvs, {name = key, type = stattype, value = value})
        end

        if selectedChar["CHAR_APPEREANCE"] then 
            exports['fivem-appearance']:setPlayerAppearance(json.decode(selectedChar["CHAR_APPEREANCE"]))
        end

        TriggerEvent("save-load:setGlobalVariables", kpvs)
        TriggerEvent("multichar:charIdChanged")

        ResetEntityAlpha(GetPlayerPed(-1))

        Citizen.Wait(1000)
        DoScreenFadeIn(1000)

        charLoaded = true
    else
        makingchar = true
        TriggerEvent("save-load:createDefaultVariables")
        TriggerEvent("save-load:setGlobalVariables", {{name = "CHAR_ID", type = "int", value = math.random(10000, 99999)}})
        TriggerEvent("multichar:charIdChanged")

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
                TriggerEvent("save-load:getDefaultVariables", function(playerData) 
                    TriggerEvent("save-load:setGlobalVariables", {{name = "CHAR_APPEREANCE", type = "string", value = json.encode(appearance)}})
                    playerData["CHAR_APPEREANCE"] = json.encode(appearance)
                    table.insert(chars, playerData)

                    TriggerServerEvent("save-load:saveData", charsPath, chars)
                    charLoaded = true
                    makingchar = false
                end)
            end
        end, config)
    end

    TriggerEvent("side-menu:removeOptions", {{id = "BANK_BALANCE"}, {id = "CASH_BALANCE"}, {id = "CHAR_1"}, {id = "CHAR_2"}, {id = "CHAR_3"}, {id = "NEW_CHAR"}})
    TriggerEvent("garage:spawnvehicles")
    TriggerEvent("multichar:charSpawned")
    DeleteFreeroamPeds()
end


RegisterNetEvent("save-load:loadDataResult")
AddEventHandler("save-load:loadDataResult", function(data, path)
    if path == charsPath then 
        if data then  
            chars = data
            MulticharSelector()
        else
            chars = json.decode("[]")
            TriggerServerEvent("save-load:saveData", charsPath, chars)
            MulticharSelector()
        end
    end
end)


local freeRoamPeds = {}
function SpawnFreeroamPeds() 
    for i, char in pairs(chars) do 
        local appearance = json.decode(char["CHAR_APPEREANCE"])
        local lastLoc = json.decode(char["LAST_LOCATION"])

        local charModel = appearance.model
        RequestModel(charModel)
        while not HasModelLoaded(charModel) do 
            Citizen.Wait(1)
        end

        local ped = CreatePed(26, GetHashKey(charModel), lastLoc.x, lastLoc.y, lastLoc.z, 0.0, false, true)
        SetEntityInvincible(ped, true)
        TaskWanderStandard(ped, 10.0, 10)
        table.insert(freeRoamPeds, ped)
        exports['fivem-appearance']:setPedAppearance(ped, appearance)
    end
end

function DeleteFreeroamPeds()
    for _, ped in pairs(freeRoamPeds) do 
        DeleteEntity(ped)
    end
end

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1)
        if freeRoamPeds[charSelected] and not charLoaded then
            local pedCoords = GetEntityCoords(freeRoamPeds[charSelected]) 
            SetEntityCoords(GetPlayerPed(-1), pedCoords.x, pedCoords.y, pedCoords.z - 1, 0.0, 0.0, 0.0, false)
        elseif not makingchar and not charLoaded then 
            SetEntityCoords(GetPlayerPed(-1), -29.3665, -1701.6086, 2493.6851, 0.0, 0.0, 0.0, false)
        end
    end
end)

function MulticharSelector()
    charSelected = nil
    charLoaded = false
    SetEntityAlpha(GetPlayerPed(-1), 0, false)
    --SetEntityCollision(GetPlayerPed(-1), false, false)
    SpawnFreeroamPeds(chars)

    local options = {
        {id = "BANK_BALANCE", label = "Bank:", quantity = "$0"},
        {id = "CASH_BALANCE", label = "Cash:", quantity = "$0"},
    }

    for i, char in pairs(chars) do
        table.insert(options, {id = "CHAR_"..i, label = "Char "..i, cb = function() 
            charSelected = i
            DoScreenFadeOut(100)
            Citizen.Wait(150)
            CharacterData()
        end, selectCB = function()
            DoScreenFadeOut(100)
            Citizen.Wait(150)
            charSelected = i
            TriggerEvent("side-menu:updateOptions", {
                {id = "BANK_BALANCE", label = "Bank:", quantity = "$"..char["BANK_BALANCE"]},
                {id = "CASH_BALANCE", label = "Cash:", quantity = "$"..char["CASH_BALANCE"]},
            })

            Citizen.Wait(5000)
            DoScreenFadeIn(1000)
        end})
    end

    if #chars < maxChars then 
        table.insert(options, {id = "NEW_CHAR", label = "Create New Character", cb = function() 
            ResetEntityAlpha(GetPlayerPed(-1))
            SetEntityCollision(GetPlayerPed(-1), true, true)
            SetEntityCoords(GetPlayerPed(-1), -516.3452, -254.1074, 35.1, 0.0, 0.0, 0.0, false)
            charSelected = #chars + 1
            CharacterData()

            TriggerEvent("side-menu:removeOptions", {{id = "BANK_BALANCE"}, {id = "CASH_BALANCE"}, {id = "CHAR_1"}, {id = "CHAR_2"}, {id = "CHAR_3"}, {id = "NEW_CHAR"}})
        end})
    end

    TriggerEvent("side-menu:addOptions", options)
end

RegisterCommand("testchar", function()
    charsPath = "./characters/"..GetExternalKvpString("save-load", "PLAYER_LICENSE")..".json"

    TriggerServerEvent("save-load:loadData", charsPath, GetPlayerServerId(PlayerId()))
end, false)

AddEventHandler("playerSpawned", function(spawn)
    if charSelected then 
        TriggerEvent("multichar:charDied")
        table.remove(chars, charSelected)
        TriggerServerEvent("save-load:saveData", charsPath, chars)
        charSelected = nil
    end

    charsPath = "./characters/"..GetExternalKvpString("save-load", "PLAYER_LICENSE")..".json"
    TriggerServerEvent("save-load:loadData", charsPath, GetPlayerServerId(PlayerId()))
end)




Citizen.CreateThread(function()
	while true do 
        if chars and chars[charSelected] and charLoaded then
            TriggerEvent("save-load:getDefaultVariables", function(data)
                chars[charSelected] = data
            end)

            TriggerServerEvent("save-load:saveData", charsPath, chars)
        end
		
		Citizen.Wait(3000)
	end
end)

