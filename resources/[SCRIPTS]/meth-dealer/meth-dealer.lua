-- Define the coordinates where you want to place the map blip
local blipWeed = vector3(-680.0983, -924.1004, 23.0767)

-- Function to create a map blip
function CreateMapBlip()
    local blip = AddBlipForCoord(blipWeed)

    -- Set the blip properties
    SetBlipSprite(blip, 499) -- You can change the sprite ID as needed.
    SetBlipDisplay(blip, 30)
    SetBlipScale(blip, 1.0)
    SetBlipColour(blip, 30) -- You can change the color as needed.
    SetBlipAsShortRange(blip, true)

    -- Set the blip name (optional)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Meth Dealer Location")
    EndTextCommandSetBlipName(blip)
end

-- Call the function to create the map blip
CreateMapBlip()