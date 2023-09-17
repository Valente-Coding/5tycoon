local foodLocations = {
    {
        coords = vector4(-1183.0332, -883.9528, 13.7542, 301.8334),
        spawnCoords = vector4(-1180.6283, -876.4772, 13.4027, 29.1767),
        ped = nil,
        deliveryPoints = {
            vector4(-1309.0474, -930.8871, 13.3582, 110.3461),
            vector4(-1319.8501, -934.9029, 16.3586, 22.1771),
            vector4(-1338.9120, -941.3922, 12.3540, 320.6392),
            vector4(-1321.3136, -1045.6879, 7.4616, 120.0556),
            vector4(-1042.3718, -1024.6628, 2.1504, 43.0940),
            vector4(-1016.7921, -1016.6194, 2.1504, 60.4081),
            vector4(-995.3930, -985.9973, 2.1503, 210.0669),
            vector4(-1091.5673, -1040.3364, 2.1504, 218.1610),
            vector4(-1114.6580, -1046.7469, 2.1504, 206.1863),
            vector4(-1124.9486, -1061.3243, 2.1504, 210.9070),
            vector4(-1161.5492, -1099.4874, 2.1972, 63.2213),
            vector4(-1160.6652, -1101.8666, 6.5313, 63.8950),
            vector4(-942.4454, -1076.5808, 2.1502, 196.7789),
            vector4(-951.9570, -1078.3942, 2.1506, 206.8295),
            vector4(-963.8021, -1084.3667, 2.1503, 194.5392),
            vector4(-960.3717, -1109.0918, 2.1503, 31.4832),
            vector4(-969.7958, -1093.7235, 2.1503, 183.7249),
            vector4(-978.3218, -1108.1678, 2.1503, 42.6714),
            vector4(-991.4036, -1103.6378, 2.1503, 242.3146),
            vector4(-1025.1420, -1138.4993, 2.1586, 22.9391),
            vector4(-1039.3029, -1131.3679, 2.1586, 196.9866),
            vector4(-1034.9657, -1146.5043, 2.1586, 32.4729),
            vector4(-1053.7230, -1143.7816, 2.1586, 208.4567),
            vector4(-1046.5311, -1159.1184, 2.1586, 125.9426),
            vector4(-1064.1283, -1159.3303, 2.1586, 30.5669),
            vector4(-1073.5122, -1152.3158, 2.1586, 178.0578),
            vector4(-1068.8879, -1162.0165, 2.1586, 91.0988),
            vector4(-1114.2527, -1193.0571, 2.3331, 30.3959),
            vector4(-1091.1691, -925.6136, 3.1581, 34.4459),
            vector4(-1056.9783, -910.3572, 3.8657, 22.7449),
            vector4(-1035.7135, -894.8409, 4.9705, 50.2486),
            vector4(-1151.7386, -913.0704, 6.6288, 209.4166),
            vector4(-1154.5363, -932.1017, 2.6576, 192.2443)
        }
    }
}

Citizen.CreateThread(function()
    local blips = {}

    for _, location in pairs(foodLocations) do
        local blip = AddBlipForCoord(location.coords.x, location.coords.y, location.coords.z)
        SetBlipSprite(blip, 103)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.8)
        SetBlipColour(blip, 49)
        SetBlipAsShortRange(blip, false)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Food Deliveries")
        EndTextCommandSetBlipName(blip)
        local pedModel = "a_m_y_business_02"
        RequestModel(pedModel)
        while not HasModelLoaded(pedModel) do
            Citizen.Wait(1)
        end
        local pedSpawn = CreatePed(26, GetHashKey(pedModel), location.coords.x, location.coords.y, location.coords.z - 1, location.coords.w, false, true)
        SetEntityInvincible(pedSpawn, true)
        location.ped = pedSpawn
    end
end)

function GetRandomPedToDeliver(coords)
    local availablePeds = {
        "a_f_m_bevhills_01",
        "a_f_m_business_02",
        "a_f_m_eastsa_01",
        "a_f_m_fatbla_01",
        "a_f_m_fatwhite_01",
        "a_f_m_soucent_01",
        "a_f_o_genstreet_01",
        "a_f_y_business_02",
        "a_f_y_eastsa_03",
        "a_f_y_scdressy_01",
        "a_f_y_soucent_02",
        "a_f_y_tourist_02",
        "a_f_y_smartcaspat_01",
        "a_f_y_gencaspat_01",
        "a_m_m_bevhills_01",
        "a_m_m_bevhills_02",
        "a_m_m_eastsa_02",
        "a_m_m_genfat_01",
        "a_m_m_genfat_02",
        "a_m_m_indian_01",
        "a_m_m_mexcntry_0",
        "a_m_m_og_boss_01",
        "a_m_m_prolhost_01",
        "a_m_m_soucent_04",
        "a_m_m_trampbeac_01",
        "a_m_m_tranvest_02",
        "a_m_o_beach_01",
        "a_m_o_soucent_01",
        "a_m_y_beachvesp_0",
        "a_m_y_bevhills_01",
        "a_m_y_downtown_01",
        "a_m_y_epsilon_02",
        "a_m_y_indian_01",
        "a_m_y_soucent_01",
        "a_m_y_yoga_01"
    }
    local pedModel = math.random(1, #availablePeds)
    RequestModel(pedModel)
    while not HasModelLoaded(pedModel) do
        Citizen.Wait(1)
    end
    local pedSpawn = CreatePed(26, GetHashKey(pedModel), coords.x, coords.y, coords.z - 1, coords.w, false, true)
    SetEntityInvincible(pedSpawn, true)
    location.ped = pedSpawn
end

local deliveryMissionState = 0

function getRandomDeliveryPoints(deliveryPoints)
    local availablePoints = {}
    local selectedPoints = {}

    for _, point in pairs(deliveryPoints) do
        table.insert(availablePoints, point)
    end

    for _ = 1, 5 do
        local index = math.random(1, #availablePoints)
        local selectedPoint = table.remove(availablePoints, index)
        table.insert(selectedPoints, selectedPoint)
    end

    return {selectedPoints[1], selectedPoints[2], selectedPoints[3], selectedPoints[4], selectedPoints[5]}
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
    local foodData = json.decode(GetExternalKvpString("save-load", "FOODDELIVERY_DATA"))
    local modelHash = nil
    local spawnedVeh = nil
    
    if foodData.level == 0 then
        modelHash = GetHashKey("faggio2")
    elseif foodData.level == 1 then
        modelHash = GetHashKey("bagger")
    elseif foodData.level == 2 then
        modelHash = GetHashKey("daemon")
    elseif foodData.level == 3 then
        modelHash = GetHashKey("pcj")
    elseif foodData.level == 4 then
        modelHash = GetHashKey("bati")    
    end

    return SpawnVehicle(modelHash, coords)
end

local deliveryBlip = nil

function NewWaypoint(coords, name)
    RemoveBlip(deliveryBlip)
    deliveryBlip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipRoute(deliveryBlip, true)
    SetBlipRouteColour(deliveryBlip, 5)
    SetBlipSprite(deliveryBlip, 1)
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

        for _, depot in pairs (foodLocations) do
            TaskSetBlockingOfNonTemporaryEvents(depot.ped, true)
            FreezeEntityPosition(depot.ped, true)
            if #(coords - vector3(depot.coords.x, depot.coords.y, depot.coords.z)) < 20.0 then
                if #(coords - vector3(depot.coords.x, depot.coords.y, depot.coords.z)) < 2.0 then
                    if menuDisplay == false then
                        menuDisplay = true
                        if deliveryMissionState == 0 then
                            TriggerEvent("side-menu:addOptions", {{id = "food_start_job", label = "Start Job", cb = function()
                                deliveryMissionState = 1
                                missionVeh = SelectVehicle(depot.spawnCoords)
                                destination = getRandomDeliveryPoints(depot.deliveryPoints)
                                NewWaypoint(destination[1], "Delivery Point")
                                GetRandomPedToDeliver(destination[1])
                                currentDepot = depot
                                TriggerEvent("side-menu:removeOptions", {{id = "food_start_job"}})
                            end}})
                        end
                    end
                else
                    if menuDisplay == true then
                        menuDisplay = false
                        TriggerEvent("side-menu:removeOptions", {{id = "food_start_job"}})
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
                    distance = #(coords - destination[1])
                    if distance < 5 then
                        distance = nil
                        deliveryMissionState = 2
                        NewWaypoint(destination[2], "Delivery Point")
                    end                 
                end
            end
            if destination[2] and deliveryMissionState == 2 then
                distance = #(vehCoords - destination[2])
                if distance < 50 then
                    distance = #(coords - destination[2])
                    if distance < 5 then
                        distance = nil
                        deliveryMissionState = 3
                        NewWaypoint(destination[3], "Delivery Point")
                    end                 
                end
            end
            if destination[3] and deliveryMissionState == 3 then
                distance = #(vehCoords - destination[3])
                if distance < 50 then
                    distance = #(coords - destination[3])
                    if distance < 5 then
                        distance = nil
                        deliveryMissionState = 4
                        NewWaypoint(destination[4], "Delivery Point")
                    end                 
                end
            end
            if destination[4] and deliveryMissionState == 4 then
                distance = #(vehCoords - destination[4])
                if distance < 50 then
                    distance = #(coords - destination[4])
                    if distance < 5 then
                        distance = nil
                        deliveryMissionState = 5
                        NewWaypoint(destination[5], "Delivery Point")
                    end                 
                end
            end
            if destination[5] and deliveryMissionState == 5 then
                distance = #(vehCoords - destination[5])
                if distance < 50 then
                    distance = #(coords - destination[5])
                    if distance < 5 then
                        distance = nil
                        deliveryMissionState = 6
                        local foodData = json.decode(GetExternalKvpString("save-load", "FOODDELIVERY_DATA"))
                        if foodData.level < 2 then
                            NewWaypoint(currentDepot.spawnCoords, "Return")
                        else
                            SetEntityCoords(missionVeh, currentDepot.spawnCoords.x, currentDepot.spawnCoords.y, currentDepot.spawnCoords.z, 0, 0, 0, false)
                        end
                    end                 
                end
            end

            distance = #(vehCoords - vector3(currentDepot.spawnCoords.x, currentDepot.spawnCoords.y, currentDepot.spawnCoords.z))
            if deliveryMissionState == 6 and distance < 50 then
                DrawMarker(25, currentDepot.spawnCoords.x, currentDepot.spawnCoords.y, currentDepot.spawnCoords.z, 0, 0, 0, 0, 0, 0, 5.0, 5.0, 1.0, 255, 0, 0, 1.0, false, true, false, false, false, false, false)
                if distance < 5 then
                    RemoveBlip(deliveryBlip)
                    deliveryBlip = nil
                    deliveryMissionState = 0
                    DeleteEntity(missionVeh)
                    local payment = math.random(1500, 3000)
                    local foodData = json.decode(GetExternalKvpString("save-load", "FOODDELIVERY_DATA"))
                    payment = math.floor(payment + (payment * (foodData.level / 5)))
                    foodData.jobs = foodData.jobs + 1
                    if foodData.level < 5 then
                        foodData.level = math.floor(foodData.jobs / 5)
                        if foodData.level == 5 then
                            foodData.canBuy = true
                        end
                    end

                    TriggerEvent("save-load:updateData", {{name = "FOODDELIVERY_DATA", type = "string", value = json.encode(foodData)}})
                    TriggerEvent("bank:changeBank", payment)
                end
            end
        end
    end
end)