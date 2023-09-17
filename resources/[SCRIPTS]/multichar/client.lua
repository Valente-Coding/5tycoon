local charsPath = ""
local charSelected = nil
local chars = nil

RegisterCommand("selectchar", function(source, args, rawCommand)
    if args[1] then 
        charSelected = tonumber(args[1])
        charsPath = "./characters/"..GetExternalKvpString("save-load", "PLAYER_LICENSE")..".json"

        TriggerServerEvent("save-load:loadData", charsPath, GetPlayerServerId(PlayerId()))
    end
end)

RegisterCommand("delchar", function(source, args, rawCommand)
    if args[1] then 
        charSelected = tonumber(args[1])
        table.remove(chars, charSelected)
        charsPath = "./characters/"..GetExternalKvpString("save-load", "PLAYER_LICENSE")..".json"

        TriggerServerEvent("save-load:saveData", charsPath, chars)
    end
end)


function CharacterData(data)
    if data then 
        local kpvs = {}
        for key, value in pairs(data) do 
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

        if data["CHAR_APPEREANCE"] then 
            exports['fivem-appearance']:setPlayerAppearance(json.decode(data["CHAR_APPEREANCE"]))
        end

        TriggerEvent("save-load:setGlobalVariables", kpvs)
    else
        TriggerEvent("save-load:createDefaultVariables")

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
                    playerData["CHAR_APPEREANCE"] = json.encode(appearance)
                    table.insert(chars, playerData)

                    TriggerServerEvent("save-load:saveData", charsPath, chars)
                end)
            end
        end, config)
    end
end


RegisterNetEvent("save-load:loadDataResult")
AddEventHandler("save-load:loadDataResult", function(data, path)
    if path == charsPath then 
        chars = data
        CharacterData(data[charSelected])
    end
end)