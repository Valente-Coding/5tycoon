local repairLocations = {
    {coords = vector3(-1155.1377, -2006.1425, 13.1803)},
    {coords = vector3(731.4940, -1088.7712, 22.1690)},
    {coords = vector3(-339.0858, -136.8183, 39.0096)},
    {coords = vector3(1174.7692, 2640.1323, 37.7546)},
    {coords = vector3(110.6880, 6626.7266, 31.7872)}
}

local menuDisplay = false
local vehHealth = nil
local lastVehHealth = nil

Citizen.CreateThread(function()
    local blips = {}
    
    for _, location in ipairs(repairLocations) do
        local blip = AddBlipForCoord(location.coords.x, location.coords.y, location.coords.z)
        SetBlipSprite(blip, 779)
        SetBlipScale(blip, 1.0)
        SetBlipColour(blip, 39)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Auto Repair Shop")
        EndTextCommandSetBlipName(blip)
        table.insert(blips, blip)
    end

    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local isPlayerInVehicle = IsPedInAnyVehicle(playerPed, false)

        for _, location in ipairs(repairLocations) do
            local distance = #(playerCoords - location.coords)

            if distance <= 50.0 then
                DrawMarker(
                    1,
                    location.coords.x,
                    location.coords.y,
                    location.coords.z - 1.0,
                    0.0, 0.0, 0.0,
                    0, 0, 0,
                    5.0, 5.0, 1.0,
                    0, 191, 255, 100,
                    false, false, true, 2, false, nil, nil, false
                )
                
                if distance <= 5.0 and isPlayerInVehicle then
                    local vehicle = GetVehiclePedIsIn(playerPed, false)
                    vehHealth = GetEntityHealth(vehicle)
                    if vehHealth ~= lastVehHealth then
                        lastVehHealth = vehHealth
                        local repairCost = ((1000 - vehHealth) * 2)
                        TriggerEvent("side-menu:updateOptions", {{id = "autoshop_repair_cost", label = "Repair Cost", quantity = "$"..repairCost}})
                    end
                    if menuDisplay == false then
                        menuDisplay = true
                        local repairCost = ((1000 - vehHealth) * 2)
                        if repairCost ~= 0 then
                            TriggerEvent("side-menu:addOptions", {
                                {id = "autoshop_repair_cost", label = "Repair Cost", quantity = "$"..repairCost},
                                {id = "autoshop_repair", label = "Repair", cb = function()
                                    TriggerEvent("bank:changeBank", -repairCost, function(removed)
                                        if removed == true then
                                            if DoesEntityExist(vehicle) then
                                                SetVehicleFixed(vehicle)
                                                SetVehicleDirtLevel(vehicle, 0.0)
                                            end
                                        end
                                    end)
                            end}})
                        else
                            TriggerEvent("side-menu:addOptions", {{id = "autoshop_no_repair", label = "No Repairs Needed"}})
                        end
                    end
                else
                    if menuDisplay == true then
                        menuDisplay = false
                        TriggerEvent("side-menu:removeOptions", {{id = "autoshop_repair_cost"}, {id = "autoshop_repair"}, {id = "autoshop_no_repair"}})
                    end
                end
            end
        end
    end
end)