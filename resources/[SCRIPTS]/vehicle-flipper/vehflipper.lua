local MenuDisplay = false
local OnMenu = false
local OnMission = false

local Location = {
    {coords = vector4(153.1738, -3210.4968, 5.9097, 89.5784)},
}



Citizen.CreateThread(function()

    for _, location in ipairs(Location) do
        local blip = AddBlipForCoord(location.coords.x, location.coords.y, location.coords.z)
        SetBlipSprite(blip, 643)
        SetBlipScale(blip, 0.7)
        SetBlipColour(blip, 1)
        SetBlipAsShortRange(blip, false)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Vehicle Flipper")
        EndTextCommandSetBlipName(blip)
        local pedModel = "a_m_m_eastsa_02"
        RequestModel(pedModel)
        while not HasModelLoaded(pedModel) do
            Citizen.Wait(1)
        end
        local pedSpawn = CreatePed(26, GetHashKey(pedModel), location.coords.x, location.coords.y, location.coords.z - 1, location.coords.w, false, true)
        SetEntityInvincible(pedSpawn, true)
        location.ped = pedSpawn
    end
end)



function CloseAllMenus(cooldown, stay)
    Citizen.CreateThread(function()   
        if cooldown then
            Citizen.Wait(cooldown)
        end

        if stay then

        else
            menuDisplay = false
        end
    end)

    TriggerEvent("side-menu:resetOptions")
end



Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        for _, location in ipairs(Location) do
            local ped = location.ped
            local pedCoords = GetEntityCoords(ped)
            local playerCoords = GetEntityCoords(PlayerPedId())
            local distance = #(pedCoords - playerCoords)
            if distance < 1.5 and OnMenu == false and OnMission == false then
                TriggerEvent("side-menu:addOptions", {{id = "shaddy_vehicle_dealer", label = "Jobs", cb = function()
                    MenuDisplay = true
                    OnMenu = true
                    CloseAllMenus(1, false)
                    if MenuDisplay and OnMenu then
                        TriggerEvent("side-menu:addOptions",
                        {{id = "easy_job_start", label = "Get an easy job", quantity = 20000, cb = function()
                            OnMenu = false
                            MenuDisplay = false
                            OnMission = true
                        end},
                        {id = "hard_job_start", label = "Get an hard job", cb = function()
                            OnMenu = false
                            MenuDisplay = false
                            OnMission = true
                        end},})
                    end
                end}})
            end
        end
    end
end)