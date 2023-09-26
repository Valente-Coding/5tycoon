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


Citizen.CreateThread(function()
    while true do
        Wait(1)
        local playerPed = GetPlayerPed(-1)
        local playerCoords = GetEntityCoords(playerPed)

        distance = #(playerCoords - blipWeed)

        if distance < 50 then
            local menuDisplay = false
            if distance < 3 then
                if menuDisplay == false then
                    menuDisplay = true
                    TriggerEvent("side-menu:addOptions", {{id = "weed_dealer_small_package", label = "Buy loose weed", quantity = "$100"}, {id = "weed_dealer_medium_package", label = "Buy a medium brick", quantity = "$1000"}, {id = "weed_dealer_big_package", label = "Buy a big brick", quantity = "$10000"}})
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