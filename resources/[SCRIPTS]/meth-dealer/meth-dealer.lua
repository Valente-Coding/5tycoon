local blipMeth = vector3(-680.0983, -924.1004, 23.0767)


function CreateMapBlip()
    local blip = AddBlipForCoord(blipMeth.x, blipMeth.y, blipMeth.z + 1)

    SetBlipSprite(blip, 499)
    SetBlipScale(blip, 0.7)
    SetBlipColour(blip, 30)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Meth Dealer")
    EndTextCommandSetBlipName(blip)
end

CreateMapBlip()