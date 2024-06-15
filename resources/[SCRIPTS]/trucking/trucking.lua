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
    --{
    --    coords = vector3(-320.4866, -1389.6117, 36.5002),
    --    spawnCoords = vector4(-340.8572, -1400.7527, 30.6168, 149.6355),
    --    ped = nil,
    --    pedHeading = 145.0,
    --    deliveryPoints = {
    --        vector3(857.8163, -2346.6355, 30.3312),
    --        vector3(864.7427, -2119.1694, 30.4448),
    --        vector3(870.3019, -1566.9204, 30.4959),
    --        vector3(158.2436, -1512.8971, 29.1397),
    --        vector3(-667.3304, -1202.5023, 10.6121),
    --        vector3(-596.4522, -900.6324, 25.5801),
    --        vector3(-1233.1493, -253.8546, 39.0920),
    --        vector3(-32.6461, -94.9570, 57.2725),
    --        vector3(100.1880, 290.0016, 109.9827),
    --        vector3(-990.8285, -298.5917, 37.8134),
    --        vector3(-701.6105, -299.5074, 36.6379),
    --        vector3(533.6143, -177.3482, 54.4632),
    --        vector3(966.0208, -8.9768, 80.6905),
    --    },
    --}
}

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

