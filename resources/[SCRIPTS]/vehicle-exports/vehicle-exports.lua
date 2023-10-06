local blipExports = vector3(482.7004, -1321.0811, 29.2033)
local heading = 28.1755
local vehicles = json.decode(getGlobalKvpStrings())

local randomCarLocation = {
    vector4(),
    vector4(),
    vector4(),
    vector4(),
    vector4(),
    vector4(),
    vector4(),
    vector4(),
    vector4(),
    vector4()
}


function CreateMapBlip()
    local blip = AddBlipForCoord(blipExports)

    SetBlipSprite(blip, 380)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.7)
    SetBlipColour(blip, 21)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Vehicle Exports")
    EndTextCommandSetBlipName(blip)
    local pedModel = "a_m_m_eastsa_02"
    RequestModel(pedModel)
    while not HasModelLoaded(pedModel) do
        Citizen.Wait(1)
    end
    local pedSpawn = CreatePed(26, GetHashKey(pedModel), blipExports, heading, false, true)
    SetEntityInvincible(pedSpawn, true)
end



function GetRandomCar()

    local pickRandom = math.random(1, #randomCarModel)

    local selectedPickupPoint = randomCarModel.model[pickRandom]

    return selectedPickupPoint

end



Citizen.CreateThread(function()
    while true do
        Wait(1)

        -- if playerCanSeeBlip then
        --     CreateMapBlip()
        -- end
        
        -- if playerCanSeeBlip then
        --     ADD JOBS
        -- end
    end
end)