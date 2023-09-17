local truckDepots = {
    {
        coords = vector3(1208.5696, -3115.0537, 5.5403),
        spawnCoords = vector4(1207.7811, -3091.3716, 5.5371, 90.6691),
        ped = nil,
        pedHeading = 100.0,
        deliveryPoints = {
            vector3(857.8163, -2346.6355, 30.3312),
            vector3(864.7427, -2119.1694, 30.4448),
            vector3(870.3019, -1566.9204, 30.4959),
            vector3(158.2436, -1512.8971, 29.1397),
            vector3(-667.3304, -1202.5023, 10.6121),
            vector3(-596.4522, -900.6324, 25.5801),
            vector3(-1233.1493, -253.8546, 39.0920),
            vector3(-32.6461, -94.9570, 57.2725),
            vector3(100.1880, 290.0016, 109.9827),
            vector3(-990.8285, -298.5917, 37.8134),
            vector3(-701.6105, -299.5074, 36.6379),
            vector3(533.6143, -177.3482, 54.4632),
            vector3(966.0208, -8.9768, 80.6905),
        },
    },
    {
        coords = vector3(-320.4866, -1389.6117, 36.5002),
        spawnCoords = vector4(-340.8572, -1400.7527, 30.6168, 149.6355),
        ped = nil,
        pedHeading = 145.0,
        deliveryPoints = {
            vector3(857.8163, -2346.6355, 30.3312),
            vector3(864.7427, -2119.1694, 30.4448),
            vector3(870.3019, -1566.9204, 30.4959),
            vector3(158.2436, -1512.8971, 29.1397),
            vector3(-667.3304, -1202.5023, 10.6121),
            vector3(-596.4522, -900.6324, 25.5801),
            vector3(-1233.1493, -253.8546, 39.0920),
            vector3(-32.6461, -94.9570, 57.2725),
            vector3(100.1880, 290.0016, 109.9827),
            vector3(-990.8285, -298.5917, 37.8134),
            vector3(-701.6105, -299.5074, 36.6379),
            vector3(533.6143, -177.3482, 54.4632),
            vector3(966.0208, -8.9768, 80.6905),
        },
    }
}

Citizen.CreateThread(function()
    local blips = {}

    for _, location in pairs(truckDepots) do
        local blip = AddBlipForCoord(location.coords.x, location.coords.y, location.coords.z)
        SetBlipSprite(blip, 477)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 1.0)
        SetBlipColour(blip, 5)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Trucking Depot")
        EndTextCommandSetBlipName(blip)
        local pedModel = "a_m_m_eastsa_01"
        RequestModel(pedModel)
        while not HasModelLoaded(pedModel) do
            Citizen.Wait(1)
        end
        local pedSpawn = CreatePed(26, GetHashKey(pedModel), location.coords.x, location.coords.y, location.coords.z - 1, location.pedHeading, false, true)
        SetEntityInvincible(pedSpawn, true)
        location.ped = pedSpawn
    end
end)


local truckMissionState = 0


-- Function to select a random coordinate from the array
function GetRandomDeliveryPoint(deliveryPoints)
    local randomIndex = math.random(1, #deliveryPoints)
    return deliveryPoints[randomIndex]
end


function SpawnVehicle(modelHash, coords)
    local isModelValid = IsModelValid(modelHash)

    if isModelValid then
        RequestModel(modelHash) -- Request the model to be loaded
        while not HasModelLoaded(modelHash) do
            Citizen.Wait(1)
        end

        local vehicle = CreateVehicle(modelHash, coords.x, coords.y, coords.z, coords.w, true, false)

        -- Set the vehicle as the player's ped vehicle (optional)
        local playerPed = PlayerPedId()
        TaskWarpPedIntoVehicle(playerPed, vehicle, -1)

        return vehicle
    else
        print("Invalid model.")
        return nil
    end
end

function SelectVehicle(coords)
    local truckData = json.decode(GetExternalKvpString("save-load", "TRUCK_DATA"))
    local modelHash = nil
    local trailerHash = nil
    local spawnedVeh = nil
    
    if truckData.level == 0 or truckData.level == 1 then
        modelHash = GetHashKey("sadler")
    elseif truckData.level == 2 or truckData.level == 3 then
        modelHash = GetHashKey("burrito3")
    elseif truckData.level == 4 or truckData.level == 5 then
        modelHash = GetHashKey("mule")
    elseif truckData.level == 6 or truckData.level == 7 then
        modelHash = GetHashKey("benson")
    elseif truckData.level == 8 then
        modelHash = GetHashKey("pounder")    
    elseif truckData.level == 9 or truckData.level == 10 then
        modelHash = GetHashKey("phantom")
        trailerHash = GetHashKey("trailers")
        spawnedVeh = SpawnVehicle(modelHash, coords)

        if trailerHash then
            local trailer = SpawnVehicle(trailerHash, coords)
            if trailer then
                AttachVehicleToTrailer(spawnedVeh, trailer, 10.0)
            end
        end

        return spawnedVeh
    end

    return SpawnVehicle(modelHash, coords)
end

local menuDisplay = false
local truckingBlip = nil

Citizen.CreateThread(function()
    local missionVeh = nil
    local destination = nil
    local vehPed = nil
    local currentDepot = nil
    while true do
        Citizen.Wait(1)
        local playerPed = GetPlayerPed(-1)
        local coords = GetEntityCoords(playerPed)

        for _, depot in pairs (truckDepots) do
            TaskSetBlockingOfNonTemporaryEvents(depot.ped, true)
            FreezeEntityPosition(depot.ped, true)
            if #(coords - depot.coords) < 20.0 then
                if #(coords - depot.coords) < 2.0 then
                    if menuDisplay == false then
                        menuDisplay = true
                        if truckMissionState == 0 then
                            TriggerEvent("side-menu:addOptions", {{id = "trucking_start_job", label = "Start Job", cb = function()
                                truckMissionState = 1
                                missionVeh = SelectVehicle(depot.spawnCoords)
                                destination = GetRandomDeliveryPoint(depot.deliveryPoints)
                                truckingBlip = AddBlipForCoord(destination.x, destination.y, destination.z)
                                SetBlipRoute(truckingBlip, true)
                                SetBlipRouteColour(truckingBlip, 5)
                                SetBlipSprite(truckingBlip, 478)
                                SetBlipDisplay(truckingBlip, 2)
                                SetBlipScale(truckingBlip, 0.8)
                                SetBlipColour(truckingBlip, 5)
                                SetBlipAsShortRange(truckingBlip, true)
                                BeginTextCommandSetBlipName("STRING")
                                AddTextComponentString("Delivery Point")
                                EndTextCommandSetBlipName(truckingBlip)
                                currentDepot = depot
                                TriggerEvent("side-menu:removeOptions", {{id = "trucking_start_job"}})
                            end}})
                        end
                    end
                else
                    if menuDisplay == true then
                        menuDisplay = false
                        TriggerEvent("side-menu:removeOptions", {{id = "trucking_start_job"}})
                    end
                end
            end
        end
       

        vehPed = GetVehiclePedIsIn(playerPed, false)
        if missionVeh ~= nil and missionVeh == vehPed then
            vehCoords = GetEntityCoords(missionVeh)
            if destination then
                distance = #(vehCoords - destination)
                if distance < 50 then
                    DrawMarker(25, destination.x, destination.y, destination.z, 0, 0, 0, 0, 0, 0, 5.0, 5.0, 1.0, 255, 0, 0, 1.0, false, true, false, false, false, false, false)
                    if distance < 5 and truckMissionState == 1 then
                        destination = nil
                        local truckData = json.decode(GetExternalKvpString("save-load", "TRUCK_DATA"))
                        truckMissionState = 2
                        if truckData.level < 2 then
                            TriggerEvent('chatMessage', 'Go back to the depot to receive your paycheck.', {255, 0, 0})
                            RemoveBlip(truckingBlip)
                            truckingBlip = AddBlipForCoord(currentDepot.spawnCoords.x, currentDepot.spawnCoords.y, currentDepot.spawnCoords.z)
                            SetBlipRoute(truckingBlip, true)
                            SetBlipRouteColour(truckingBlip, 5)
                            SetBlipSprite(truckingBlip, 1)
                            SetBlipDisplay(truckingBlip, 2)
                            SetBlipScale(truckingBlip, 0.8)
                            SetBlipColour(truckingBlip, 5)
                            SetBlipAsShortRange(truckingBlip, true)
                            BeginTextCommandSetBlipName("STRING")
                            AddTextComponentString("Return")
                            EndTextCommandSetBlipName(truckingBlip)
                        else
                            SetEntityCoords(missionVeh, currentDepot.spawnCoords.x, currentDepot.spawnCoords.y, currentDepot.spawnCoords.z, 0, 0, 0, false)
                        end
                    end
                end
            end

            distance = #(vehCoords - vector3(currentDepot.spawnCoords.x, currentDepot.spawnCoords.y, currentDepot.spawnCoords.z))
            if truckMissionState == 2 and distance < 50 then
                DrawMarker(25, currentDepot.spawnCoords.x, currentDepot.spawnCoords.y, currentDepot.spawnCoords.z, 0, 0, 0, 0, 0, 0, 5.0, 5.0, 1.0, 255, 0, 0, 1.0, false, true, false, false, false, false, false)
                if distance < 5 then
                    RemoveBlip(truckingBlip)
                    truckMissionState = 0
                    TriggerEvent('chatMessage', 'You got paid.', {255, 0, 0})
                    DeleteEntity(missionVeh)
                    local payment = math.random(1000, 2000)
                    local truckData = json.decode(GetExternalKvpString("save-load", "TRUCK_DATA"))
                    payment = math.floor(payment + (payment * (truckData.level / 10)))
                    truckData.jobs = truckData.jobs + 1
                    if truckData.level < 10 then
                        truckData.level = math.floor(truckData.jobs / 10)
                        if truckData.level == 10 then
                            TriggerEvent('chatMessage', 'You reached max level.', {255, 0, 0})
                            truckData.canBuy = true
                        end
                    end

                    TriggerEvent("save-load:setGlobalVariables", {{name = "TRUCK_DATA", type = "string", value = json.encode(truckData)}})
                    TriggerEvent("bank:changeBank", payment)
                end
            end
        end
    end
end)