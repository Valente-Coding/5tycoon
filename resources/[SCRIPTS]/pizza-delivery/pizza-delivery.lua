local MenuDisplay = false
local OnMission = false
local SpawnedMissionVeh = nil
local WaypointsCreated = {}
local RearOfVehicle = nil
local BoxModel = nil
local Box = nil
local prop = nil
local DeliveriesCompleted = false
local NumberOfDeliveries = nil
local DeliveriesList = {}

--NEED TO TEST SPAWN OF BOX ON BOTH FAGGIOS FAGGIO2 | FAGGIO

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
    BoxModel = nil
    Box = nil
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
    BoxModel = nil
    Box = nil
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
    -- Adjust the heading by 180 degrees to get the rear direction
    local angle = math.rad(heading - 90)
    local x = coords.x + distance * math.cos(angle)
    local y = coords.y + distance * math.sin(angle)

    return vector3(x, y, coords.z)
end

function PickupBox(boxPickup)
    local playerPed = GetPlayerPed(-1)
    local playerCoords = GetEntityCoords(playerPed)
    BoxModel = GetHashKey("prop_pizza_box_01")

    RequestModel(BoxModel)
    while not HasModelLoaded(BoxModel) do
        Citizen.Wait(1)
    end

    RequestAnimDict('anim@heists@box_carry@')
    while not HasAnimDictLoaded('anim@heists@box_carry@') do
        Citizen.Wait(1)
    end

    TaskPlayAnim(playerPed, 'anim@heists@box_carry@', 'idle', 8.0, -8.0, -1, 50, 0, false, false, false)

    Box = CreateObject(BoxModel, playerCoords.x, playerCoords.y, playerCoords.z, true, true, true)
    AttachEntityToEntity(Box, playerPed, GetPedBoneIndex(playerPed, 60309), 0.025, 0.08, 0.255, -145.0, 290.0, 0.0,
        true, true, false, true, 1, true)
end

function DropBox(boxDropoff)
    local playerPed = GetPlayerPed(-1)

    DetachEntity(Box, false, false)
    DeleteEntity(Box)
    ClearPedTasks(playerPed)
    SetModelAsNoLongerNeeded(Box)
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
    for i = 1, NumberOfDeliveries, 1 do
        
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
    
end)