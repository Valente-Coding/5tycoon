-- Define the coordinates where you want to place the map blip
local blipWeed = vector3(76.7247, -1948.2946, 21.1741)

-- Function to create a map blip
function CreateMapBlip()
    local blip = AddBlipForCoord(blipWeed)

    -- Set the blip properties
    SetBlipSprite(blip, 497) -- You can change the sprite ID as needed.
    SetBlipDisplay(blip, 37)
    SetBlipScale(blip, 1.0)
    SetBlipColour(blip, 37) -- You can change the color as needed.
    SetBlipAsShortRange(blip, true)

    -- Set the blip name (optional)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Cocaine Dealer Location")
    EndTextCommandSetBlipName(blip)
end

-- Call the function to create the map blip
CreateMapBlip()