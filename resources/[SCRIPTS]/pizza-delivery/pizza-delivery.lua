local MenuDisplay = false
local OnMission = false
local SpawnedMissionVeh = nil
local WaypointsCreated = {}
local RearOfVehicle = nil
local BoxModel = nil
local Boxes = {}
local prop = nil
local DeliveriesCompleted = false
local NumberOfDeliveries = nil
local DeliveriesList = {}
local pizza_ped = nil

--NEED TO TEST SPAWN OF BOX ON ALL BIKES

local shopCoords = vector3(538.0167, 101.0657, 96.5154)

local MissionVehSpawnPoint = vector4(534.0449, 98.1231, 95.8393, 111.1317)

local DeliveryLocations = {
    {coords = vector4(352.8840, -142.1516, 66.6883, 336.6996)},
    {coords = vector4(315.4273, -127.6960, 69.9769, 300.5992)},
    {coords = vector4(206.5419, -85.4131, 69.2303, 320.5391)},
    {coords = vector4(151.8950, -72.2296, 67.6748, 303.7264)},
    {coords = vector4(44.4700, -29.7022, 69.3948, 351.0341)},
    {coords = vector4(17.6281, -13.4799, 70.1162, 1.2589)},
    {coords = vector4(3.3512, 36.3320, 71.5304, 160.7409)},
    {coords = vector4(-23.5509, -23.1969, 73.2453, 39.6906)},
    {coords = vector4(-41.2128, -58.6034, 63.6596, 49.3704)},
    {coords = vector4(329.3545, -225.1010, 54.2218, 19.2883)},
    {coords = vector4(336.8373, -224.7392, 54.2218, 67.7717)},
    {coords = vector4(342.5986, -209.6110, 54.2218, 91.9533)},
    {coords = vector4(319.2983, -196.2302, 54.2264, 171.1218)},
    {coords = vector4(311.4390, -203.5754, 54.2218, 246.3873)},
    {coords = vector4(312.9554, -218.6556, 54.2218, 275.4140)},
    {coords = vector4(318.0927, 562.1662, 154.5393, 14.9102)},
    {coords = vector4(331.1593, 466.0323, 151.1773, 13.3131)},
    {coords = vector4(347.0937, 441.0122, 147.7020, 298.8540)},
    {coords = vector4(373.4636, 428.0474, 145.6845, 39.3713)},
    {coords = vector4(231.9250, 672.7750, 189.9455, 30.3517)},
    {coords = vector4(215.7179, 620.5779, 187.6097, 82.8299)},
    {coords = vector4(128.2679, 566.1705, 183.9595, 325.2135)},
    {coords = vector4(119.2916, 564.5428, 183.9592, 1.9169)},
    {coords = vector4(84.8310, 562.8320, 182.5733, 354.7420)},
    {coords = vector4(8.4496, 540.0305, 176.0274, 343.2691)},
    {coords = vector4(-66.1548, 491.1794, 144.6804, 272.2845)},
    {coords = vector4(-7.5049, 468.4937, 145.8717, 321.5077)},
    {coords = vector4(57.7795, 450.0781, 147.0314, 331.4542)},
    {coords = vector4(43.3254, 468.1015, 148.0959, 251.8222)},
    {coords = vector4(223.4402, 514.1429, 140.7672, 47.7934)},
    {coords = vector4(1060.8601, -378.7049, 68.2311, 220.8671)},
    {coords = vector4(1029.4583, -409.1934, 65.9493, 215.2174)},
    {coords = vector4(1011.8624, -422.7015, 64.9528, 285.1942)},
    {coords = vector4(987.8803, -433.3712, 63.8909, 221.6617)},
    {coords = vector4(967.2228, -451.7144, 62.7896, 218.5313)},
    {coords = vector4(943.9718, -463.6181, 61.3957, 140.1016)},
    {coords = vector4(906.6165, -490.0168, 59.4362, 205.7331)},
    {coords = vector4(879.1467, -498.5617, 57.8760, 226.6476)},
    {coords = vector4(920.0397, -570.1446, 58.3663, 208.5900)},
    {coords = vector4(965.9835, -543.0161, 59.3591, 211.1909)},
    {coords = vector4(1006.0899, -511.4730, 60.8339, 148.7974)},
    {coords = vector4(1089.9586, -484.4218, 65.6605, 80.2621)},
    {coords = vector4(1100.1779, -411.4412, 67.5551, 85.4772)}
}

local NpcModels = {
    "a_m_m_afriamer_01", "a_m_m_beach_01", "a_m_m_beach_02", "a_m_m_bevhills_01", "a_m_m_bevhills_02",
    "a_m_m_business_01", "a_m_m_eastsa_01", "a_m_m_eastsa_02", "a_m_m_farmer_01", "a_m_m_fatlatin_01",
    "a_m_m_genfat_01", "a_m_m_genfat_02", "a_m_m_golfer_01", "a_m_m_hasjew_01", "a_m_m_hillbilly_01",
    "a_m_m_hillbilly_02", "a_m_m_indian_01", "a_m_m_ktown_01", "a_m_m_malibu_01", "a_m_m_mexcntry_01",
    "a_m_m_mexlabor_01", "a_m_m_og_boss_01", "a_m_m_paparazzi_01", "a_m_m_polynesian_01",
    "a_m_m_prolhost_01", "a_m_m_rurmeth_01", "a_m_m_salton_01", "a_m_m_salton_02", "a_m_m_salton_03",
    "a_m_m_salton_04", "a_m_m_skater_01", "a_m_m_skidrow_01", "a_m_m_socenlat_01", "a_m_m_soucent_01",
    "a_m_m_soucent_02", "a_m_m_soucent_03", "a_m_m_soucent_04", "a_m_m_stlat_02", "a_m_m_tennis_01",
    "a_m_m_tourist_01", "a_m_m_tramp_01", "a_m_m_trampbeac_01", "a_m_m_tranvest_01", "a_m_m_tranvest_02",
    "a_m_o_acult_01", "a_m_o_acult_02", "a_m_o_beach_01", "a_m_o_genstreet_01", "a_m_o_ktown_01",
    "a_m_o_salton_01", "a_m_o_soucent_01", "a_m_o_soucent_02", "a_m_o_soucent_03", "a_m_o_tramp_01",
    "a_m_y_acult_01", "a_m_y_acult_02", "a_m_y_beach_01", "a_m_y_beach_02", "a_m_y_beach_03",
    "a_m_y_beachvesp_01", "a_m_y_beachvesp_02", "a_m_y_bevhills_01", "a_m_y_bevhills_02",
    "a_m_y_breakdance_01", "a_m_y_busicas_01", "a_m_y_business_01", "a_m_y_business_02",
    "a_m_y_business_03", "a_m_y_cyclist_01", "a_m_y_dhill_01", "a_m_y_downtown_01", "a_m_y_eastsa_01",
    "a_m_y_eastsa_02", "a_m_y_epsilon_01", "a_m_y_epsilon_02", "a_m_y_gay_01", "a_m_y_gay_02",
    "a_m_y_genstreet_01", "a_m_y_genstreet_02", "a_m_y_golfer_01", "a_m_y_hasjew_01", "a_m_y_hiker_01",
    "a_m_y_hippy_01", "a_m_y_hipster_01", "a_m_y_hipster_02", "a_m_y_hipster_03", "a_m_y_indian_01",
    "a_m_y_jetski_01", "a_m_y_juggalo_01", "a_m_y_ktown_01", "a_m_y_ktown_02", "a_m_y_latino_01",
    "a_m_y_methhead_01", "a_m_y_mexthug_01", "a_m_y_motox_01", "a_m_y_motox_02", "a_m_y_musclbeac_01",
    "a_m_y_musclbeac_02", "a_m_y_polynesian_01", "a_m_y_roadcyc_01", "a_m_y_runner_01",
    "a_m_y_runner_02", "a_m_y_salton_01", "a_m_y_skater_01", "a_m_y_skater_02", "a_m_y_soucent_01",
    "a_m_y_soucent_02", "a_m_y_soucent_03", "a_m_y_soucent_04", "a_m_y_stbla_01", "a_m_y_stbla_02",
    "a_m_y_stlat_01", "a_m_y_stwhi_01", "a_m_y_stwhi_02", "a_m_y_sunbathe_01", "a_m_y_surfer_01",
    "a_m_y_vindouche_01", "a_m_y_vinewood_01", "a_m_y_vinewood_02", "a_m_y_vinewood_03",
    "a_m_y_vinewood_04", "a_m_y_yoga_01"
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
    DeleteEntity(prop)
    RearOfVehicle = nil
    prop = nil
end

function FinishMissionSuccess()
    OnMission = false
    DeleteMissionVeh()
    WaypointsCreated = {}
    if BoxModel == not nil then
        DeleteEntity(BoxModel)
        BoxModel = nil
    end

    for _, box in pairs(Boxes) do
        DeleteEntity(box)
    end

    ClearPedTasks(GetPlayerPed(-1))
    Boxes = {}
    pizza_ped = nil
    DeliveriesCompleted = false
    NumberOfDeliveries = nil
    CloseAllMenus()
    RemoveAllWaypoints()
    GettingPaid()
end

function MissionCanceled()
    OnMission = false
    DeleteMissionVeh()
    WaypointsCreated = {}
    if BoxModel == not nil then
        DeleteEntity(BoxModel)
        BoxModel = nil
    end

    for _, box in pairs(Boxes) do
        DeleteEntity(box)
    end

    ClearPedTasks(GetPlayerPed(-1))
    Boxes = {}
    pizza_ped = nil
    DeliveriesCompleted = false
    NumberOfDeliveries = nil
    CloseAllMenus()
    RemoveAllWaypoints()
end

function CreateMarkers(id, coordsX, coordsY, coordsZ, color)
    local chosenColor = color

    if chosenColor == "green" then
        chosenColor = {0, 255, 0, 255}
    elseif chosenColor == "blue" then
        chosenColor = {0, 0, 255, 255}
    end

    DrawMarker(id, coordsX, coordsY, coordsZ, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, chosenColor[1],
        chosenColor[2], chosenColor[3], chosenColor[4], false, false, 2, false, false, false, false)
end

function GetRearOfVehicle(heading, coords, distance)
    local angle = math.rad(heading - 90)
    local x = coords.x + distance * math.cos(angle)
    local y = coords.y + distance * math.sin(angle)

    return vector3(x, y, coords.z)
end

function PickupBox(ped, numBoxes)
    local playerCoords = GetEntityCoords(ped)
    BoxModel = GetHashKey("prop_pizza_box_01")

    RequestModel(BoxModel)
    while not HasModelLoaded(BoxModel) do
        Citizen.Wait(1)
    end

    RequestAnimDict('anim@heists@box_carry@')
    while not HasAnimDictLoaded('anim@heists@box_carry@') do
        Citizen.Wait(1)
    end

    TaskPlayAnim(ped, 'anim@heists@box_carry@', 'idle', 8.0, -8.0, -1, 50, 0, false, false, false)

    for i = 1, numBoxes, 1 do
        local tempBox = CreateObject(BoxModel, playerCoords.x, playerCoords.y, playerCoords.z, true, true, true)

        AttachEntityToEntity(tempBox, ped, GetPedBoneIndex(ped, 60309), 0.025, 0.08, 0.255 + ((i - 1) * 0.005), -145.0, 290.0, 0.0,
            true, true, false, true, 1, true)

        table.insert(Boxes, tempBox)
    end
end

function DropBox(ped)

    for _, box in pairs(Boxes) do
        DetachEntity(box, false, false)
        DeleteEntity(box)
    end

    ClearPedTasks(ped)
end

function GettingPaid()
    local pizzaData = json.decode(GetExternalKvpString("save-load", "FOODDELIVERY_DATA"))
    local payment = math.random(1000, 2000)
    payment = math.floor(payment + (payment * (pizzaData.level / 5)))
    TriggerEvent("notification:send", {
        time = 5000,
        color = "green",
        text = "You have been paid $" .. payment
    })
    TriggerEvent("bank:changeBank", payment)
    pizzaData.jobs = pizzaData.jobs + 1
    if pizzaData.level < 10 and pizzaData.jobs <= 100 then
        pizzaData.level = math.floor(pizzaData.jobs / 10)
        if pizzaData.level == 100 then
            TriggerEvent('notification:center', {
                time = 5000,
                text = "You reached max level."
            })
            pizzaData.canBuy = true
        end
    end
    TriggerEvent("save-load:setGlobalVariables", {{
        name = "FOODDELIVERY_DATA",
        type = "string",
        value = json.encode(pizzaData)
    }})
end

function GettingNumberOfDeliveries()
    local pizzaData = json.decode(GetExternalKvpString("save-load", "FOODDELIVERY_DATA"))

    if pizzaData.level < 3 then
        NumberOfDeliveries = math.random(5, 7)
    elseif pizzaData.level >= 3 and pizzaData.level < 6 then
        NumberOfDeliveries = math.random(3, 7)
    elseif pizzaData.level >= 6 and pizzaData.level < 10 then
        NumberOfDeliveries = math.random(1, 5)
    else
        NumberOfDeliveries = math.random(1, 2)    
    end
end

function GettingNumberOfPizzasForDeliveries()
    GettingNumberOfDeliveries()
    for i = 1, NumberOfDeliveries, 1 do
        local deliveriesToDo = math.random(1, #DeliveryLocations)
        local numberOfPizzaBoxes = math.random(1, 3)
        table.insert(DeliveriesList, {coords = DeliveryLocations[deliveriesToDo].coords, pizzas = numberOfPizzaBoxes})
    end
end

function SpawnMissionVeh()
    local pizzaData = json.decode(GetExternalKvpString("save-load", "FOODDELIVERY_DATA"))
    local vehModel = nil
    if pizzaData.level < 3 then
        vehModel = GetHashKey("faggio2")
        RequestModel(vehModel)
        while not HasModelLoaded(vehModel) do
            Citizen.Wait(1)
        end
    elseif pizzaData.level >= 3 and pizzaData.level < 6 then
        vehModel = GetHashKey("faggio")
        RequestModel(vehModel)
        while not HasModelLoaded(vehModel) do
            Citizen.Wait(1)
        end
    elseif pizzaData.level >= 6 and pizzaData.level < 9 then
        vehModel = GetHashKey("bagger")
        RequestModel(vehModel)
        while not HasModelLoaded(vehModel) do
            Citizen.Wait(1)
        end
    else
        vehModel = GetHashKey("reever")
        RequestModel(vehModel)
        while not HasModelLoaded(vehModel) do
            Citizen.Wait(1)
        end
    end

    SpawnedMissionVeh = CreateVehicle(vehModel, MissionVehSpawnPoint, true, false)
    SetVehicleOnGroundProperly(SpawnedMissionVeh)
    
    SetVehicleNumberPlateText(SpawnedMissionVeh, "PIZZA")

    local propHash = GetHashKey("h4_prop_h4_box_delivery_01a")
    RequestModel(propHash)
    while not HasModelLoaded(propHash) do
        Citizen.Wait(1)
    end

    prop = CreateObject(propHash, MissionVehSpawnPoint.x, MissionVehSpawnPoint.y, MissionVehSpawnPoint.z, true, true, true)

    AttachEntityToEntity(prop, SpawnedMissionVeh, GetEntityBoneIndexByName(SpawnedMissionVeh, "chassis"), 0.0, 0.0, -0.05, 0.0, 0.0, 270.0, true, true, false, true, 1, true)

    FreezeEntityPosition(prop, true)
end

function Mission()
    OnMission = true

    SpawnMissionVeh()

    WaypointerCreate("pizza_job_mission_veh", nil, SpawnedMissionVeh, 144, true, 46, "Pizza Bike", true, false, false)

    GettingNumberOfPizzasForDeliveries()

    for _, spots in ipairs(DeliveriesList) do
        PickupBox(GetPlayerPed(-1), spots.pizzas)
        TriggerEvent("notification:send", {time = 7000, color = "blue", text = "You have " .. NumberOfDeliveries .. " deliveries to make."})
        TriggerEvent("notification:send", {time = 10000, color = "blue", text = "Get the pizzas in the transporation box on the motorcycle."})

        local rearOfDeliveryBike = GetRearOfVehicle(GetEntityHeading(SpawnedMissionVeh), GetEntityCoords(SpawnedMissionVeh), 1.5)

        while true do
            Citizen.Wait(1)
            local playerPed = GetPlayerPed(-1)
            local playerCoords = GetEntityCoords(playerPed)
            local distance = #(playerCoords - rearOfDeliveryBike)

            CreateMarkers(1, rearOfDeliveryBike.x, rearOfDeliveryBike.y, rearOfDeliveryBike.z, "blue")
            
            if distance < 1.5 then
                DropBox(GetPlayerPed(-1))
                break
            end
        end
    end

    for _, spots in ipairs(DeliveriesList) do
        WaypointerCreate("pizza_job_delivery", spots.coords, nil, 144, true, 46, "Delivery Location", true, false, true)
        TriggerEvent("notification:send", {time = 10000, color = "blue", text = "Deliver the pizzas to the location."})

        local npcModel = NpcModels[math.random(1, #NpcModels)]
        RequestModel(GetHashKey(npcModel))
        
        while not HasModelLoaded(GetHashKey(npcModel)) do
            Citizen.Wait(1)
        end

        pizza_ped = CreateBrainlessNpc(npcModel, spots.coords.x, spots.coords.y, spots.coords.z, spots.coords.w, true)

        local rearOfDeliveryBike = GetRearOfVehicle(GetEntityHeading(SpawnedMissionVeh), GetEntityCoords(SpawnedMissionVeh), 1.5)

        while true do
            Citizen.Wait(1)
            local playerPed = GetPlayerPed(-1)
            local playerCoords = GetEntityCoords(playerPed)
            local distance = #(playerCoords - rearOfDeliveryBike)

            CreateMarkers(1, rearOfDeliveryBike.x, rearOfDeliveryBike.y, rearOfDeliveryBike.z, "blue")

            if distance < 1.5 then
                PickupBox(GetPlayerPed(-1), spots.pizzas)
                break
            end
        end

        TriggerEvent("notification:send", {time = 7000, color = "green", text = "Deliver the " .. spots.pizzas .. " pizzas to the customer."})

        while true do
            Citizen.Wait(1)
            local playerPed = GetPlayerPed(-1)
            local playerCoords = GetEntityCoords(playerPed)
            local distance = #(playerCoords - spots.coords)

            if distance < 1.5 then
                PickupBox(pizza_ped, spots.pizzas)
                DropBox(playerPed)
                break
            end
        end
    end

    RemoveAllWaypoints()
    WaypointerCreate("pizza_job_mission_veh", nil, SpawnedMissionVeh, 144, true, 46, "Pizza Bike", true, false, false)
    TriggerEvent("notification:send", {time = 10000, color = "blue", text = "Return the bike to the shop."})

    WaypointerCreate("pizza_job_shop_deliver_veh", vector3(MissionVehSpawnPoint.x, MissionVehSpawnPoint.y, MissionVehSpawnPoint.z), nil, 144, true, 46, "Return Bike", false, true, true)

    while true do
        Citizen.Wait(1)
        local playerPed = GetPlayerPed(-1)
        local playerCoords = GetEntityCoords(playerPed)
        local distance = #(playerCoords - vector3(MissionVehSpawnPoint.x, MissionVehSpawnPoint.y, MissionVehSpawnPoint.z))

        CreateMarkers(1, MissionVehSpawnPoint.x, MissionVehSpawnPoint.y, MissionVehSpawnPoint.z, "green")

        if distance < 1.5 then
            FinishMissionSuccess()
            break
        end
    end
end

Citizen.CreateThread(function()
        local blip = AddBlipForCoord(shopCoords)

        SetBlipSprite(blip, 267)
        SetBlipScale(blip, 0.7)
        SetBlipColour(blip, 59)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Pizza Deliveries Job")
        EndTextCommandSetBlipName(blip)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        local playerPed = GetPlayerPed(-1)
        local playerCoords = GetEntityCoords(playerPed)
        local distance = #(playerCoords - shopCoords)

        local pizzaData = json.decode(GetExternalKvpString("save-load", "FOODDELIVERY_DATA"))

        if distance < 2.0 and not MenuDisplay then
            if not OnMission then
                MenuDisplay = true
                TriggerEvent("side-menu:addOptions", {{
                    id = "pizza_job_jobs",
                    label = "Number of Jobs:",
                    quantity = tostring(pizzaData.jobs)
                }, {
                    id = "pizza_job_level",
                    label = "Job Level:",
                    quantity = tostring(pizzaData.level)
                }, {
                    id = "pizza_job_start",
                    label = "Start Job",
                    cb = function()
                        CloseAllMenus(100)
                        Mission()
                    end
                }})
            else
                MenuDisplay = true
                TriggerEvent("side-menu:addOptions", {{
                    id = "pizza_job_cancel_mission",
                    label = "Cancel Job",
                    cb = function()
                        MissionCanceled()
                    end
                }})
            end
        elseif distance > 2.0 and distance <= 3.0 and MenuDisplay then
            CloseAllMenus()
        end
    end
end)