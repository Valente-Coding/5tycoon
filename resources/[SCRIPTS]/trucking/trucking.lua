local truckDepots = {
    {
        coords = vector3(1208.5696, -3115.0537, 5.5403),
        spawnCoords = vector4(1207.7811, -3091.3716, 5.5371, 90.6691),
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
        coords = vector3(-320.4866, -1389.6117, 36.5002)
        spawnCoords = vector4(-340.8572, -1400.7527, 30.6168, 149.6355),
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

    end
end)


local truckMissionState = 0


-- Function to select a random coordinate from the array
function GetRandomDeliveryPoint(deliveryPoints)
    local randomIndex = math.random(1, #deliveryPoints)
    return deliveryPoints[randomIndex]
end


function SpawnVehicle(modelHash)
    local isModelValid = IsModelValid(modelHash)

    if isModelValid then
        RequestModel(modelHash) -- Request the model to be loaded
        while not HasModelLoaded(modelHash) do
            Citizen.Wait(0)
        end

        local vehicle = CreateVehicle(modelHash, truckSpawnCoords1.x, truckSpawnCoords1.y, truckSpawnCoords1.z, truckSpawnCoords1.w, true, false)

        -- Set the vehicle as the player's ped vehicle (optional)
        local playerPed = PlayerPedId()
        TaskWarpPedIntoVehicle(playerPed, vehicle, -1)

        return vehicle
    else
        print("Invalid model.")
        return nil
    end
end

function SelectVehicle()
    local truckData = json.decode(GetExternalKvpString("save-load", "TRUCK_DATA"))
    local modelHash = nil
    local trailerHash = nil

    if truckData.level < 9 then
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
        end
        return SpawnVehicle(modelHash)
    elseif truckData.level == 9 or truckData.level == 10 then
        modelHash = GetHashKey("phantom")
        trailerHash = GetHashKey("trailers")
        local truck = SpawnVehicle(modelHash)

        if trailerHash then
            local trailer = SpawnVehicle(trailerHash)
            if trailer then
                AttachVehicleToTrailer(truck, trailer, 10.0)
            end
        end

        return truck
    end
end



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
            if #(coords - depot.coords) < 2.0 then
                if truckMissionState == 0 then
                    if IsControlJustReleased(0, 38) then
                        truckMissionState = 1
                        missionVeh = SelectVehicle()
                        destination = GetRandomDeliveryPoint(depot.deliveryPoints)
                        SetNewWaypoint(destination.x, destination.y)
                        currentDepot = depot
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
                            SetNewWaypoint(currentDepot.spawnCoords.x, currentDepot.spawnCoords.y)
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

                    TriggerEvent("save-load:updateData", {{name = "TRUCK_DATA", type = "string", value = json.encode(truckData)}})
                    TriggerEvent("bank:changeBank", payment)
                end
            end
        end
    end
end)