local deliveryDepots = {
    {
        coords = vector4(78.6090, 112.2691, 81.1682, 211.1308),
        spawnCoords = vector4(56.6617, 101.7133, 78.3225, 160.0659),
        ped = nil,
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
        coords = vector4(829.7604, -1945.4061, 28.9328, 174.5896),
        spawnCoords = vector4(824.8843, -1951.7849, 28.3836, 78.9346),
        ped = nil,
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

    for _, location in pairs(deliveryDepots) do
        local blip = AddBlipForCoord(location.coords.x, location.coords.y, location.coords.z)
        SetBlipSprite(blip, 800)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.8)
        SetBlipColour(blip, 66)
        SetBlipAsShortRange(blip, false)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Deliveris Depot")
        EndTextCommandSetBlipName(blip)
        local pedModel = "a_m_m_farmer_01"
        RequestModel(pedModel)
        while not HasModelLoaded(pedModel) do
            Citizen.Wait(1)
        end
        local pedSpawn = CreatePed(26, GetHashKey(pedModel), location.coords.x, location.coords.y, location.coords.z - 1, location.coords.w, false, true)
        SetEntityInvincible(pedSpawn, true)
        location.ped = pedSpawn
    end
end)

local deliveryMissionState = 0

function getRandomDeliveryPoints(deliveryDepots)
    local availablePoints = {}
    local selectedPoints = {}

    for _, point in ipairs(deliveryDepots.deliveryPoints) do
        table.insert(availablePoints, point)
    end

    for _ = 1, 3 do
        local index = math.random(1, #availablePoints)
        local selectedPoint = table.remove(availablePoints, index)
        table.insert(selectedPoints, selectedPoint)
    end

    return selectedPoints[1], selectedPoints[2], selectedPoints[3]
end

function SpawnVehicle(modelHash, coords)
    local isModelValid = IsModelValid(modelHash)

    if isModelValid then
        RequestModel(modelHash)
        while not HasModelLoaded(modelHash) do
            Citizen.Wait(1)
        end

        local vehicle = CreateVehicle(modelHash, coords.x, coords.y, coords.z, coords.w, true, false)

        local playerPed = PlayerPedId()
        TaskWarpPedIntoVehicle(playerPed, vehicle, -1)

        return vehicle
    else
        print("Invalid model.")
        return nil
    end
end

function SelectVehicle(coords)
    local deliveryData = json.decode(GetExternalKvpString("save-load", "DELIVERY_DATA"))
    local modelHash = nil
    local spawnedVeh = nil
    
    if truckData.level == 0 or truckData.level == 1 then
        modelHash = GetHashKey("premier")
    elseif truckData.level == 2 or truckData.level == 3 then
        modelHash = GetHashKey("speedo")
    elseif truckData.level == 4 or truckData.level == 5 then
        modelHash = GetHashKey("mule")
    elseif truckData.level == 6 or truckData.level == 7 then
        modelHash = GetHashKey("benson")
    elseif truckData.level == 8 then
        modelHash = GetHashKey("pounder")    
    end

    return SpawnVehicle(modelHash, coords)
end