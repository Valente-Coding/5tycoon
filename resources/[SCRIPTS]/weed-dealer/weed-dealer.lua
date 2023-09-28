-- Define the coordinates where you want to place the map blip
local blipWeed = vector3(-210.4544, -1607.1135, 34.8693)

-- Function to create a map blip
function CreateMapBlip()
    local blip = AddBlipForCoord(blipWeed)

    -- Set the blip properties
    SetBlipSprite(blip, 496) -- You can change the sprite ID as needed.
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.7)
    SetBlipColour(blip, 2) -- You can change the color as needed.
    SetBlipAsShortRange(blip, true)

    -- Set the blip name (optional)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Weed Dealer")
    EndTextCommandSetBlipName(blip)
end

-- Call the function to create the map blip
CreateMapBlip()

local menuDisplay = false
local weedBaggie = 100
local mediumPackage = 1000
local largePackage = 10000

Citizen.CreateThread(function()
    while true do
        Wait(1)
        local playerPed = GetPlayerPed(-1)
        local playerCoords = GetEntityCoords(playerPed)

        distance = #(playerCoords - blipWeed)

        if distance < 50 then
            if distance < 2 then
                if menuDisplay == false then
                    menuDisplay = true
                    TriggerEvent("side-menu:addOptions", {{id = "weed_dealer_small_package", label = "Buy loose weed", quantity = "$"..weedBaggie, cb = function()
                        TriggerEvent("bank:changeBank", -weedBaggie, function(removed)
                                if removed == true then
                                    TriggerEvent("inventory:addItems", {{id = "weed_baggies", label = "Weed Baggie", quantity = 10}})
                                    TriggerEvent("notification:send", {color = "blue", time = 5000, text = "You bought 10 weed baggies."})
                                end
                            end)
                        end},
                        {id = "weed_dealer_medium_package", label = "Buy a medium brick", quantity = "$"..tostring(mediumPackage), cb = function()
                            TriggerEvent("bank:changeBank", -weedBaggie, function(removed)
                                if removed == true then
                                    TriggerEvent("inventory:addItems", {{id = "weed_medium_package", label = "Medium Weed Package", quantity = 1}})
                                    TriggerEvent("notification:send", {color = "blue", time = 5000, text = "You bought 1 medium weed package."})
                                end
                            end)
                        end},
                        {id = "weed_dealer_big_package", label = "Buy a big brick", quantity = "$"..tostring(largePackage), cb = function()
                            TriggerEvent("bank:changeBank", -weedBaggie, function(removed)
                                if removed == true then
                                    TriggerEvent("inventory:addItems", {{id = "weed_large_package", label = "Large Weed Package", quantity = 1}})
                                    TriggerEvent("notification:send", {color = "blue", time = 5000, text = "You bought 1 large weed package."})
                                end
                            end)
                        end}})
                end
            else
                if menuDisplay == true then
                    menuDisplay = false
                    TriggerEvent("side-menu:removeOptions", {{id = "weed_dealer_small_package"}, {id = "weed_dealer_medium_package"}, {id = "weed_dealer_big_package"}})
                end
            end
        end
    end
end)