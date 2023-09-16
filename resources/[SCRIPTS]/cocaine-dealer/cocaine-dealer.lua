local blipWeed = vector3(76.7247, -1948.2946, 21.1741)


function CreateMapBlip()
    local blip = AddBlipForCoord(blipWeed.x, blipWeed.y, blipWeed.z + 1)

    SetBlipSprite(blip, 497)
    SetBlipScale(blip, 0.7)
    SetBlipColour(blip, 4)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Cocaine Dealer")
    EndTextCommandSetBlipName(blip)
end

CreateMapBlip()