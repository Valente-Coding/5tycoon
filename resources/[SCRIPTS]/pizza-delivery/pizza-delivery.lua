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

--NEED TO TEST SPAWN OF BOX ON BOTH FAGGIOS FAGGIO2 | FAGGIO

local shopCoords = vector3(215.2651, -17.2666, 74.9873)

local MissionVehSpawnPoint = vector4(226.8631, -26.3724, 69.2689, 181.6043)

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

function SpawnMissionVeh()
    local pizzaData = json.decode(GetExternalKvpString("save-load", "FOODDELIVERY_DATA"))
    local vehModel = nil
    if pizzaData.level < 3 then
        local vehModel = GetHashKey("faggio2")
        RequestModel(vehModel)
        while not HasModelLoaded(vehModel) do
            Citizen.Wait(1)
        end
        return vehModel
    else
        local vehModel = GetHashKey("faggio")
        RequestModel(vehModel)
        while not HasModelLoaded(vehModel) do
            Citizen.Wait(1)
        end
    end

    SpawnedMissionVeh = CreateVehicle(vehModel, MissionVehSpawnPoint.x, MissionVehSpawnPoint.y, MissionVehSpawnPoint.z, MissionVehSpawnPoint.w, true, false)
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
    SpawnMissionVeh()
end)