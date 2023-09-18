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
        AddTextComponentString("Deliveries Depot")
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

function getRandomDeliveryPoints(deliveryPoints)
    local availablePoints = {}
    local selectedPoints = {}

    for _, point in pairs(deliveryPoints) do
        table.insert(availablePoints, point)
    end

    for _ = 1, 3 do
        local index = math.random(1, #availablePoints)
        local selectedPoint = table.remove(availablePoints, index)
        table.insert(selectedPoints, selectedPoint)
    end

    return {selectedPoints[1], selectedPoints[2], selectedPoints[3]}
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
    
    if deliveryData.level == 0 then
        modelHash = GetHashKey("premier")
    elseif deliveryData.level == 1 then
        modelHash = GetHashKey("speedo")
    elseif deliveryData.level == 2 then
        modelHash = GetHashKey("mule")
    elseif deliveryData.level == 3 then
        modelHash = GetHashKey("benson")
    elseif deliveryData.level == 4 then
        modelHash = GetHashKey("pounder")    
    end

    return SpawnVehicle(modelHash, coords)
end

local deliveryBlip = nil

function NewWaypoint(coords, name, blipType)
    RemoveBlip(deliveryBlip)
    deliveryBlip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipRoute(deliveryBlip, true)
    SetBlipRouteColour(deliveryBlip, 5)
    SetBlipSprite(deliveryBlip, blipType)
    SetBlipDisplay(deliveryBlip, 2)
    SetBlipScale(deliveryBlip, 0.7)
    SetBlipColour(deliveryBlip, 5)
    SetBlipAsShortRange(deliveryBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(deliveryBlip)
end

local menuDisplay = false


Citizen.CreateThread(function()
    local missionVeh = nil
    local destination = nil
    local vehPed = nil
    local currentDepot = nil
    while true do
        Citizen.Wait(1)
        local playerPed = GetPlayerPed(-1)
        local coords = GetEntityCoords(playerPed)

        for _, depot in pairs (deliveryDepots) do
            TaskSetBlockingOfNonTemporaryEvents(depot.ped, true)
            FreezeEntityPosition(depot.ped, true)
            if #(coords - vector3(depot.coords.x, depot.coords.y, depot.coords.z)) < 20.0 then
                if #(coords - vector3(depot.coords.x, depot.coords.y, depot.coords.z)) < 2.0 then
                    if menuDisplay == false then
                        menuDisplay = true

                        local deliveryData = json.decode(GetExternalKvpString("save-load", "DELIVERY_DATA"))

                        TriggerEvent("side-menu:addOptions", {{id = "delivery_show_level", label = "Job Level", quantity = tostring(deliveryData.level)}, {id = "delivery_show_jobs", label = "Number of Jobs", quantity = tostring(deliveryData.jobs)}})

                        if deliveryMissionState == 0 then
                            TriggerEvent("side-menu:addOptions", {{id = "delivery_start_job", label = "Start Job", cb = function()
                                deliveryMissionState = 1
                                missionVeh = SelectVehicle(depot.spawnCoords)
                                destination = getRandomDeliveryPoints(depot.deliveryPoints)
                                NewWaypoint(destination[1], "Delivery Point", 478)
                                TriggerEvent("notification:center", {time = 5000, text = "Deliver the load"})
                                currentDepot = depot
                                TriggerEvent("side-menu:removeOptions", {{id = "delivery_start_job"}, {id = "delivery_show_level"}, {id = "delivery_show_jobs"}})
                            end}})
                        end
                    end
                else
                    if menuDisplay == true then
                        menuDisplay = false
                        TriggerEvent("side-menu:removeOptions", {{id = "delivery_start_job"}, {id = "delivery_show_level"}, {id = "delivery_show_jobs"}})
                    end
                end
            end
        end


        vehPed = GetVehiclePedIsIn(playerPed, false)
        if missionVeh ~= nil and missionVeh == vehPed then
            vehCoords = GetEntityCoords(missionVeh)
            if destination[1] and deliveryMissionState == 1 then
                distance = #(vehCoords - destination[1])
                if distance < 50 then
                    DrawMarker(25, destination[1].x, destination[1].y, destination[1].z, 0, 0, 0, 0, 0, 0, 5.0, 5.0, 1.0, 255, 0, 0, 1.0, false, true, false, false, false, false, false)
                    if distance < 5 then
                        distance = nil
                        deliveryMissionState = 2
                        NewWaypoint(destination[2], "Delivery Point", 478)
                        TriggerEvent("notification:center", {time = 5000, text = "Reach the new destination."})
                    end
                end
            end
            if destination[2] and deliveryMissionState == 2 then
                distance = #(vehCoords - destination[2])
                if distance < 50 then
                    DrawMarker(25, destination[2].x, destination[2].y, destination[2].z, 0, 0, 0, 0, 0, 0, 5.0, 5.0, 1.0, 255, 0, 0, 1.0, false, true, false, false, false, false, false)
                    if distance < 5 then
                        distance = nil
                        deliveryMissionState = 3
                        NewWaypoint(destination[3], "Delivery Point", 478)
                        TriggerEvent("notification:center", {time = 5000, text = "Reach the new destination."})
                    end
                end
            end
            if destination[3] and deliveryMissionState == 3 then
                distance = #(vehCoords - destination[3])
                if distance < 50 then
                    DrawMarker(25, destination[3].x, destination[3].y, destination[3].z, 0, 0, 0, 0, 0, 0, 5.0, 5.0, 1.0, 255, 0, 0, 1.0, false, true, false, false, false, false, false)
                    if distance < 5 then
                        distance = nil
                        deliveryMissionState = 4
                        local deliveryData = json.decode(GetExternalKvpString("save-load", "DELIVERY_DATA"))
                        if deliveryData.level < 2 then
                            NewWaypoint(currentDepot.spawnCoords, "Return", 1)
                            TriggerEvent("notification:center", {time = 5000, text = "Get back to the HQ."})
                        else
                            SetEntityCoords(missionVeh, currentDepot.spawnCoords.x, currentDepot.spawnCoords.y, currentDepot.spawnCoords.z, 0, 0, 0, false)
                        end
                    end
                end
            end

            distance = #(vehCoords - vector3(currentDepot.spawnCoords.x, currentDepot.spawnCoords.y, currentDepot.spawnCoords.z))
            if deliveryMissionState == 4 and distance < 50 then
                DrawMarker(25, currentDepot.spawnCoords.x, currentDepot.spawnCoords.y, currentDepot.spawnCoords.z, 0, 0, 0, 0, 0, 0, 5.0, 5.0, 1.0, 255, 0, 0, 1.0, false, true, false, false, false, false, false)
                if distance < 5 then
                    RemoveBlip(deliveryBlip)
                    deliveryBlip = nil
                    deliveryMissionState = 0
                    DeleteEntity(missionVeh)
                    local payment = math.random(1500, 3000)
                    local deliveryData = json.decode(GetExternalKvpString("save-load", "DELIVERY_DATA"))
                    payment = math.floor(payment + (payment * (deliveryData.level / 5)))
                    TriggerEvent("notification:center", {time = 5000, text = "You've been paid $"..payment})
                    deliveryData.jobs = deliveryData.jobs + 1
                    if deliveryData.level < 5 then
                        deliveryData.level = math.floor(deliveryData.jobs / 5)
                        if deliveryData.level == 5 then
                            deliveryData.canBuy = true
                        end
                    end

                    TriggerEvent("save-load:updateData", {{name = "DELIVERY_DATA", type = "string", value = json.encode(deliveryData)}})
                    TriggerEvent("bank:changeBank", payment)
                end
            end
        end
    end
end)