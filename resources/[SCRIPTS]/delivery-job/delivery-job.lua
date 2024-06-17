local MenuDisplay = false
local OnMission = false
local SpawnedMissionVeh = nil
local WaypointsCreated = {}
local NumberOfDeliveries = nil
local boxModel = nil
local box = nil
local rearOfVehicle = nil

local npcBlip = {{
    x = 78.6975,
    y =  112.3520,
    z =  81.1682,
    h = 218.0293
}}

local MissionVehSpawnCoords = {{
    x = 55.9178,
    y = 99.1312,
    z = 78.4701,
    h = 162.1213
}}

local DeliverMissionVehCoords = {{
    x = 62.1495,
    y = 99.3469,
    z = 78.9586,
    h = 230.9433
}}

local DeliveryLocationsCoords = {
    {x = 17.8651, y = -13.1544, z = 70.1161},
    {x = 861.7568, y = -138.0721, z = 78.9473},
    {x = 1089.8766, y = -484.2945, z = 65.6603},
    {x = 288.1832, y = -2072.7000, z = 17.6633},
    {x = -1024.5128, y = -1139.7012, z = 2.7453},
    {x = -1586.5753, y = -465.3037, z = 37.2240},
    {x = -408.8619, y = 341.5071, z = 108.9074},
    {x = 231.8713, y = 672.5370, z = 189.9455},
    {x = -1413.7098, y = 462.6288, z = 109.2086},
    {x = -1339.6400, y = 470.8774, z = 106.4068},
    {x = -1197.4911, y = 693.5770, z = 147.4055},
    {x = -1218.9117, y = 665.4808, z = 144.5327},
    {x = -1247.8588, y = 643.5211, z = 142.6175},
    {x = -1241.2505, y = 674.0414, z = 142.8135},
    {x = -1282.7496, y = 663.7361, z = 144.8517},
    {x = -1291.6276, y = 649.8867, z = 141.5014},
    {x = -1277.8016, y = 629.8503, z = 143.1928},
    {x = -1063.1342, y = -1054.7095, z = 2.1504},
    {x = -1065.4176, y = -1055.2903, z = 6.4117},
    {x = -1080.4952, y = -1036.3124, z = 2.1503},
    {x = -1091.1261, y = -1040.8497, z = 2.1504},
    {x = -1108.3718, y = -1041.6014, z = 2.1504},
    {x = -1104.3115, y = -1059.6545, z = 2.5433},
    {x = -1122.0493, y = -1046.7074, z = 2.1504},
    {x = 236.5288, y = -2045.9929, z = 18.3800},
    {x = 256.4926, y = -2023.5149, z = 19.2663},
    {x = 312.3479, y = -1956.2214, z = 24.6170},
    {x = 334.2489, y = -1978.4261, z = 24.1671},
    {x = 331.0984, y = -1981.9598, z = 24.1673},
    {x = 324.8006, y = -1989.6810, z = 24.1669},
    {x = 332.2262, y = -2018.8386, z = 22.3542},
    {x = 353.2340, y = -2036.3923, z = 22.3543},
    {x = 342.1617, y = -2063.9446, z = 20.9439},
    {x = 333.4928, y = -2056.8425, z = 20.9363},
    {x = 313.6419, y = -2040.3895, z = 20.9364},
    {x = 879.1151, y = -498.4409, z = 57.8759},
    {x = 906.6535, y = -490.1819, z = 59.4363},
    {x = 922.0914, y = -478.4556, z = 61.0831},
    {x = 943.9673, y = -463.7404, z = 61.3957},
    {x = 970.0643, y = -502.2792, z = 62.1409},
    {x = 946.5460, y = -518.5333, z = 60.6259},
    {x = 923.9193, y = -524.8077, z = 59.5744}
}

function CreateBrainlessNpc(pedModel, x, y, z, h, network)
    local ped = CreatePed(26, GetHashKey(pedModel), x, y, z, h, network, true)
    SetEntityInvincible(ped, true)
    FreezeEntityPosition(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedFleeAttributes(ped, 0, 0)
    SetPedCombatAttributes(ped, 17, 1)
    SetPedSeeingRange(ped, 0.0)
    SetPedHearingRange(ped, 0.0)
    SetPedAlertness(ped, 0)

    return ped
end

function WaypointerCreate(id, coords, entity, sprite, short, color, label, onFoot, removeBlip, setRoute)
    TriggerEvent("waypointer:add", id, {
        coords = coords,
        entity = entity,
        sprite = sprite,
        scale = 0.7,
        short = short,
        color = color,
        label = label
    }, {
        coords = coords,
        color = color,
        onFoot = onFoot,
        radarThick = 16,
        mapThick = 16,
        range = 10,
        removeBlip = removeBlip
    })

    if setRoute then
        TriggerEvent("waypointer:setroute", id)
    end

    table.insert(WaypointsCreated, id)
end

function CloseAllMenus(cooldown, stay)
    Citizen.CreateThread(function()
        if cooldown then
            Citizen.Wait(cooldown)
        end

        if stay then

        else
            MenuDisplay = false
        end
    end)

    TriggerEvent("side-menu:resetOptions")
end

function RemoveAllWaypoints()
    for _, waypoint in pairs(WaypointsCreated) do
        TriggerEvent("waypointer:remove", waypoint)
    end
end

function DeleteMissionVeh()
    DeleteVehicle(SpawnedMissionVeh)
    SpawnedMissionVeh = nil
end

function CreateMarkers(id, coordsX, coordsY, coordsZ, color, scale)
    local chosenColor = color

    if chosenColor == "green" then
        chosenColor = {0, 255, 0, 255}
    elseif chosenColor == "blue" then
        chosenColor = {0, 0, 255, 255}
    end

    DrawMarker(id, coordsX, coordsY, coordsZ - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, scale, scale, scale, chosenColor[1],
        chosenColor[2], chosenColor[3], chosenColor[4], false, false, 2, false, false, false, false)
end

function GetRearOfVehicle(heading, coords, distance)
    -- Adjust the heading by 180 degrees to get the rear direction
    local angle = math.rad(heading - 90)
    local x = coords.x + distance * math.cos(angle)
    local y = coords.y + distance * math.sin(angle)

    return vector3(x, y, coords.z)
end

function GettingPaid()
    local deliveryData = json.decode(GetExternalKvpString("save-load", "DELIVERY_DATA"))
    local payment = math.random(1000, 2000)
    payment = math.floor(payment + (payment * (deliveryData.level / 4)))
    TriggerEvent("notification:send", {
        time = 5000,
        color = "green",
        text = "You have been paid $" .. payment
    })
    TriggerEvent("bank:changeBank", payment)
    deliveryData.jobs = deliveryData.jobs + 1
    if deliveryData.level < 10 and deliveryData.jobs <= 100 then
        deliveryData.level = math.floor(deliveryData.jobs / 10)
        if deliveryData.level == 100 then
            TriggerEvent('notification:center', {
                time = 5000,
                text = "You reached max level."
            })
            deliveryData.canBuy = true
        end
    end
    TriggerEvent("save-load:setGlobalVariables", {{
        name = "DELIVERY_DATA",
        type = "string",
        value = json.encode(deliveryData)
    }})
end

function GetVehicleForLevel()
    local deliveryData = json.decode(GetExternalKvpString("save-load", "DELIVERY_DATA"))
    local vehicle = nil
    if deliveryData.level < 3 then
        vehicle = "monstrociti"
    elseif deliveryData.level >= 3 and deliveryData.level < 6 then
        vehicle = "speedo"
    elseif deliveryData.level >= 6 and deliveryData.level < 9 then
        vehicle = "mule"
    elseif deliveryData.level >= 9 then
        vehicle = "benson"
    end

    return vehicle
end

function SpawnMissionVeh(coords)
    local vehicle = GetHashKey(GetVehicleForLevel())
    local playerPed = GetPlayerPed(-1)

    RequestModel(vehicle)
    while not HasModelLoaded(vehicle) do
        Citizen.Wait(1)
    end

    if IsModelValid(vehicle) then
        local veh = CreateVehicle(vehicle, coords.x, coords.y, coords.z, coords.h, true, false)

        SetVehicleOnGroundProperly(veh)
        SetVehicleNumberPlateText(veh, "MAMAZIN")

        TaskWarpPedIntoVehicle(playerPed, veh, -1)

        return veh 
    else
        print("Model is not valid: " .. vehicle)
        return nil
    end
end

function GetDifferentDeliverySpots()
    local deliverySpots = {}

    -- get the number of deliveries equal to the NumberOfDeliveries but all different
    for i = 1, NumberOfDeliveries, 1 do
        local randomSpots = math.random(1, #DeliveryLocationsCoords)

        for _, spot in ipairs(deliverySpots) do
            if spot == randomSpots then
                randomSpots = math.random(1, #DeliveryLocationsCoords)
            end
        end

        table.insert(deliverySpots, randomSpots)
    end

    return deliverySpots
end

function GetCorrectRadiusForMissionVeh()
    radius = nil

    if GetVehicleForLevel() == "monstrociti" then
        radius = 3.0
    elseif GetVehicleForLevel() == "speedo" then
        radius = 4.0
    elseif GetVehicleForLevel() == "mule" then
        radius = 5.0
    elseif GetVehicleForLevel() == "benson" then
        radius = 6.0
    end
    return radius
end

function PickupBox()
    local playerPed = GetPlayerPed(-1)
    local playerCoords = GetEntityCoords(playerPed)
    boxModel = GetHashKey("hei_prop_heist_box")

    RequestModel(boxModel)
    while not HasModelLoaded(boxModel) do
        Citizen.Wait(1)
    end

    RequestAnimDict('anim@heists@box_carry@')
    while not HasAnimDictLoaded('anim@heists@box_carry@') do
        Citizen.Wait(1)
    end

    TaskPlayAnim(playerPed, 'anim@heists@box_carry@', 'idle', 8.0, -8.0, -1, 50, 0, false, false, false)

    box = CreateObject(boxModel, playerCoords.x, playerCoords.y, playerCoords.z, true, true, true)
    AttachEntityToEntity(box, playerPed, GetPedBoneIndex(playerPed, 60309), 0.025, 0.08, 0.255, -145.0, 290.0, 0.0,
        true, true, false, true, 1, true)
end

function DropBox()
    local playerPed = GetPlayerPed(-1)

    DetachEntity(box, false, false)
    DeleteEntity(box)
    ClearPedTasks(playerPed)
    SetModelAsNoLongerNeeded(box)
end

function StartingDeliveries()
    local deliverySpots = GetDifferentDeliverySpots()
    local playerPed = GetPlayerPed(-1)
    local isCompleted = false

    TriggerEvent("notification:send", {time = 7000, color = "blue", text = "You have " .. NumberOfDeliveries .. " deliveries to make."})

    for i, spot in ipairs(deliverySpots) do
        local coords = DeliveryLocationsCoords[spot]

        WaypointerCreate("delivery_job_" .. i, vector3(coords.x, coords.y, coords.z), nil, 1, true, 43, "Delivery Spot", true, false, true)

        while #(GetEntityCoords(playerPed) - vector3(coords.x, coords.y, coords.z)) > 30.0 do
            Citizen.Wait(100)
        end

        local hasPickUpBox = false
        local hasDeliveredBox = false

        while not hasPickUpBox do
            Citizen.Wait(1)
            -- I can add different radius for different vehicles here
            rearOfVehicle = GetRearOfVehicle(GetEntityHeading(SpawnedMissionVeh), GetEntityCoords(SpawnedMissionVeh), GetCorrectRadiusForMissionVeh())
            CreateMarkers(1, rearOfVehicle.x, rearOfVehicle.y, rearOfVehicle.z, "blue", 1.5)

            if #(GetEntityCoords(playerPed) - rearOfVehicle) < 1.5 then
                hasPickUpBox = true
                PickupBox()
                break
            end
        end

        while hasPickUpBox and not hasDeliveredBox do
            Citizen.Wait(1)
            CreateMarkers(1, coords.x, coords.y, coords.z, "green", 1.5)

            if #(GetEntityCoords(playerPed) - vector3(coords.x, coords.y, coords.z)) < 1.5 then
                hasDeliveredBox = true
                DropBox()
                break
            end
        end

        if hasDeliveredBox and hasPickUpBox then
            RemoveAllWaypoints()
            WaypointerCreate("delivery_job_mission_veh", nil, SpawnedMissionVeh, 1, true, 43, "Mission Vehicle", true, false, false)
        end
    end
    
    RemoveAllWaypoints()
    WaypointerCreate("delivery_job_mission_veh", nil, SpawnedMissionVeh, 1, true, 43, "Mission Vehicle", true, false, false)
    WaypointerCreate("delivery_job_depot", vector3(DeliverMissionVehCoords[1].x, DeliverMissionVehCoords[1].y, DeliverMissionVehCoords[1].z), nil, 1, true, 43, "Depot", true, true, true)
    TriggerEvent("notification:send", {time = 7000, color = "blue", text = "You have completed all deliveries. Go back to the depot."})
    isCompleted = true

    while true do
        Citizen.Wait(1)

        while #(GetEntityCoords(playerPed) - vector3(DeliverMissionVehCoords[1].x, DeliverMissionVehCoords[1].y, DeliverMissionVehCoords[1].z)) > 30.0 and not isCompleted do
            Citizen.Wait(100)
        end
    
        while #(GetEntityCoords(playerPed) - vector3(DeliverMissionVehCoords[1].x, DeliverMissionVehCoords[1].y, DeliverMissionVehCoords[1].z)) <= 30.0 and isCompleted do
            Citizen.Wait(1)
            CreateMarkers(1, DeliverMissionVehCoords[1].x, DeliverMissionVehCoords[1].y, DeliverMissionVehCoords[1].z, "green", 3.0)
    
            if #(GetEntityCoords(playerPed) - vector3(DeliverMissionVehCoords[1].x, DeliverMissionVehCoords[1].y, DeliverMissionVehCoords[1].z)) < 3.0 then
                DeleteMissionVeh()
                RemoveAllWaypoints()
                GettingPaid()
                OnMission = false
                NumberOfDeliveries = nil
                SpawnedMissionVeh = nil
                isCompleted = false
                break
            end
        end
    end
end

function Mission()
    OnMission = true
    local playerPed = GetPlayerPed(-1)
    local deliverData = json.decode(GetExternalKvpString("save-load", "DELIVERY_DATA"))

    SpawnedMissionVeh = SpawnMissionVeh(MissionVehSpawnCoords[1])

    WaypointerCreate("delivery_job_mission_veh", nil, SpawnedMissionVeh, 1, true, 43, "Mission Vehicle", true, false, false)

    StartingDeliveries()
end

Citizen.CreateThread(function()

    for _, location in ipairs(npcBlip) do
        local blip = AddBlipForCoord(location.x, location.y, location.z)
        SetBlipSprite(blip, 67)
        SetBlipScale(blip, 0.7)
        SetBlipColour(blip, 43)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Delivery Job")
        EndTextCommandSetBlipName(blip)
        local pedModel = "a_m_m_malibu_01"
        RequestModel(pedModel)
        while not HasModelLoaded(pedModel) do
            Citizen.Wait(1)
        end

        local pedSpawn = CreateBrainlessNpc(pedModel, location.x, location.y, location.z - 1, location.h, false)
        location.ped = pedSpawn
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        local playerPed = GetPlayerPed(-1)
        local playerCoords = GetEntityCoords(playerPed)
        local distance = #(playerCoords - vector3(npcBlip[1].x, npcBlip[1].y, npcBlip[1].z))

        local deliveryData = json.decode(GetExternalKvpString("save-load", "DELIVERY_DATA"))

        if distance < 2.0 and not MenuDisplay then
            if not OnMission then
                if deliveryData.level < 3 then
                    NumberOfDeliveries = math.random(1, 3)
                elseif deliveryData.level >= 3 and deliveryData.level < 6 then
                    NumberOfDeliveries = math.random(2, 5)
                elseif deliveryData.level >= 6 and deliveryData.level < 9 then
                    NumberOfDeliveries = math.random(3, 7)
                elseif deliveryData.level >= 9 then
                    NumberOfDeliveries = math.random(4, 9)
                end
                MenuDisplay = true
                TriggerEvent("side-menu:addOptions", {
                    {id = "delivery_job_jobs", label = "Number of Jobs:", quantity = tostring(deliveryData.jobs)},
                    {id = "delivery_job_level", label = "Level:", quantity = tostring(deliveryData.level)},
                    {id = "delivery_job_start", label = "Start Job", cb = function()
                        CloseAllMenus(100)
                        Mission()
                    end}
                })
            else
                MenuDisplay = true
                TriggerEvent("side-menu:addOptions", {
                    {id = "delivery_job_cancel", label = "Cancel Job", cb = function()
                        CloseAllMenus()
                        RemoveAllWaypoints()
                        DeleteMissionVeh()
                        OnMission = false
                        NumberOfDeliveries = nil
                        SpawnedMissionVeh = nil
                    end}
                })
            end
        elseif distance > 2.0 and distance <= 3.0 then
            CloseAllMenus()
        end
    end
end)