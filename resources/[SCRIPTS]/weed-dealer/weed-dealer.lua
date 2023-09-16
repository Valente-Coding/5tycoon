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
    AddTextComponentString("Cannabis Dealer Location")
    EndTextCommandSetBlipName(blip)
end

-- Call the function to create the map blip
CreateMapBlip()