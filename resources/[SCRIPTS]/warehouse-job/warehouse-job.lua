MenuDisplay = false
OnMission = false
NumberOfBoxes = 6
box = nil
boxModel = nil
WaypointsForMission = {
    
}

local pawnShopItems = {
    { item = "Wristwatch", price = 50.00 },
    { item = "Gold Ring", price = 120.00 },
    { item = "Silver Necklace", price = 80.00 },
    { item = "Pocket Knife", price = 25.00 },
    { item = "Smartphone", price = 200.00 },
    { item = "Bluetooth Speaker", price = 45.00 },
    { item = "Digital Camera", price = 150.00 },
    { item = "Tablet", price = 180.00 },
    { item = "Laptop Charger", price = 20.00 },
    { item = "Headphones", price = 35.00 },
    { item = "Video Game Controller", price = 30.00 },
    { item = "Portable Hard Drive", price = 60.00 },
    { item = "Smartwatch", price = 120.00 },
    { item = "Handheld Game Console", price = 100.00 },
    { item = "Fitness Tracker", price = 70.00 },
    { item = "Electric Shaver", price = 40.00 },
    { item = "Wallet", price = 15.00 },
    { item = "Sunglasses", price = 25.00 },
    { item = "Perfume", price = 50.00 },
    { item = "Designer Belt", price = 75.00 },
    { item = "External Battery Pack", price = 25.00 },
    { item = "Memory Card", price = 10.00 },
    { item = "Portable Speaker", price = 35.00 },
    { item = "Action Camera", price = 90.00 },
    { item = "Mini Projector", price = 100.00 },
    { item = "Binoculars", price = 60.00 },
    { item = "Electric Toothbrush", price = 30.00 },
    { item = "Compact Mirror", price = 5.00 },
    { item = "Flashlight", price = 15.00 },
    { item = "Wireless Earbuds", price = 50.00 },
    -- Adding rarer and more expensive items
    { item = "Vintage Rolex Watch", price = 5000.00 },
    { item = "Antique Gold Coin", price = 2000.00 },
    { item = "Diamond Necklace", price = 7000.00 },
    { item = "Limited Edition Designer Handbag", price = 2500.00 },
    { item = "Rare Vintage Guitar", price = 3000.00 }
}

local npcBlip = {
    {x = 152.8723, y = -3103.3269, z = 5.8963, h = 89.0579}
}

local boxesPickup = {
    {x = 140.4967, y = -3111.3965, z = 5.8963, h = 181.2294},
    {x = 138.7535, y = -3111.8469, z = 5.8963, h = 179.9865},
    {x = 122.7341, y = -3112.0239, z = 5.9886, h = 181.7740},
    {x = 137.5310, y = -3100.4888, z = 5.8958, h = 272.3730},
    {x = 144.2891, y = -3102.0286, z = 5.8963, h = 354.9503},
    {x = 134.6055, y = -3111.4075, z = 5.8963, h = 186.5516}
}

local boxesDropoff = {
    {x = 129.8775, y = -3079.5479, z = 5.8988, h = 356.6273},
    {x = 126.4262, y = -3074.5942, z = 5.9416, h = 0.9049},
    {x = 137.3327, y = -3074.7009, z = 5.8963, h = 2.4249},
    {x = 143.4873, y = -3074.7656, z = 5.8963, h = 358.6199},
    {x = 124.7388, y = -3075.8572, z = 5.9625, h = 2.3082}
}

Citizen.CreateThread(function()

    for _, location in ipairs(npcBlip) do
        local blip = AddBlipForCoord(location.x, location.y, location.z)
        SetBlipSprite(blip, 478)
        SetBlipScale(blip, 0.7)
        SetBlipColour(blip, 0)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Warehouse Job")
        EndTextCommandSetBlipName(blip)
        local pedModel = "a_m_m_farmer_01"
        RequestModel(pedModel)
        while not HasModelLoaded(pedModel) do
            Citizen.Wait(1)
        end

        local pedSpawn = CreateBrainlessNpc(pedModel, location.x, location.y, location.z - 1, location.h, false)
        location.ped = pedSpawn
    end

end)

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

function CloseAllMenus()
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
    for _, waypoint in pairs(WaypointsForMission) do
        TriggerEvent("waypointer:remove", waypoint)
    end
    WaypointsForMission = {}
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
        range = 3.0,
        removeBlip = removeBlip
    })

    if setRoute then
        TriggerEvent("waypointer:setroute", id)
    end
end

function CreateMarkers(id, coordsX, coordsY, coordsZ, color)
    local chosenColor = color

    if chosenColor == "green" then
        chosenColor = {
            0,
            255,
            0,
            255
        }
    elseif chosenColor == "blue" then
        chosenColor = {
            0,
            0,
            255,
            255
        }
    end

    DrawMarker(id, coordsX, coordsY, coordsZ, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, chosenColor[1], chosenColor[2], chosenColor[3], chosenColor[4], false, false, 2, false, false, false, false)
end

function GettingPaid()
    local warehouseData = json.decode(GetExternalKvpString("save-load", "WAREHOUSE_DATA"))
    local payment = math.random(1000, 2000)
    payment = math.floor(payment + (payment * (warehouseData.level / 10)))
    TriggerEvent("notification:send", {time = 5000, color = "green", text = "You have been paid $" .. payment})
    TriggerEvent("bank:changeBank", payment)
    warehouseData.jobs = warehouseData.jobs + 1
    if warehouseData.level < 10 and warehouseData.jobs <= 100 then
        warehouseData.level = math.floor(warehouseData.jobs / 10)
        if warehouseData.level == 100 then
            TriggerEvent('notification:center', {time = 5000, text = "You reached max level."})
            warehouseData.canBuy = true
        end
    end
    TriggerEvent("save-load:setGlobalVariables", {{name = "WAREHOUSE_DATA", type = "string", value = json.encode(warehouseData)}})
end

function ChanceToStealItemFunc()
    local stealItemChance = math.random(1, 100)
    if stealItemChance <= 10 then
        local itemToSteal = pawnShopItems[math.random(1, #pawnShopItems)]

        TriggerEvent("side-menu:addOptions", {
            {id = "warehouse_job_steal_item", label = "---[Stealing]"},
            {id = "warehouse_job_steal_item_name", label = "Item: " .. itemToSteal.item},
            {id = "warehouse_job_steal_item_confirm", label = "Steal", cb = function()
                local chanceToGetCaught = math.random(1, 100)
                if chanceToGetCaught <= 20 then
                    TriggerEvent("bank:changeBank", -500, function(check, needAmount)
                        if check then
                            TriggerEvent("notification:send", {text = "You have been caught stealing from one of the boxes! Fine for stealing: $500", color = "red", time = 10000})
                        else
                            TriggerEvent("notification:send", {text = "You do not have enough money to pay the fine. Police has been alerted.", color = "red", time = 10000})
                            SetPlayerWantedLevel(PlayerId(), 1, false)
                            SetPlayerWantedLevelNow(PlayerId(), false)
                        end
                    end)
                else
                    TriggerEvent("inventory:addItems", {{id = itemToSteal.item, label = itemToSteal.item, quantity = 1}})
                end
                CloseAllMenus()
            end},
            {id = "warehouse_job_steal_item_cancel", label = "Do not steal", cb = function()
                CloseAllMenus()
            end}
        })
    end
end

function PickupBox(boxPickup)
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

    SetEntityCoords(playerPed, boxPickup.x, boxPickup.y, boxPickup.z - 1, false, false, false, false)
    SetEntityHeading(playerPed, boxPickup.h)
    TaskPlayAnim(playerPed, 'anim@heists@box_carry@', 'idle', 8.0, -8.0, -1, 50, 0, false, false, false)

    box = CreateObject(boxModel, playerCoords.x, playerCoords.y, playerCoords.z, true, true, true)
    AttachEntityToEntity(box, playerPed, GetPedBoneIndex(playerPed, 60309), 0.025, 0.08, 0.255, -145.0, 290.0, 0.0, true, true, false, true, 1, true)
end

function DropBox(boxDropoff)
    local playerPed = GetPlayerPed(-1)

    SetEntityCoords(playerPed, boxDropoff.x, boxDropoff.y, boxDropoff.z - 1, false, false, false, false)
    SetEntityHeading(playerPed, boxDropoff.h)
    DetachEntity(box, false, false)
    DeleteEntity(box)
    ClearPedTasks(playerPed)
    SetModelAsNoLongerNeeded(box)
end

function StartMission()
    OnMission = true
    
    local playerPed = GetPlayerPed(-1)
    local playerCoords = GetEntityCoords(playerPed)

    for i = 1, NumberOfBoxes, 1 do
        local boxPickup = boxesPickup[math.random(1, #boxesPickup)]
        local boxDropoff = boxesDropoff[math.random(1, #boxesDropoff)]

        WaypointerCreate("warehouse_job_box_pickup_" .. i, boxPickup, nil, 1, false, 5, "Box Pickup", true, true, true)
        table.insert(WaypointsForMission, "warehouse_job_box_pickup_" .. i)

        while #(playerCoords - vector3(boxPickup.x, boxPickup.y, boxPickup.z)) > 1.0 do
            Citizen.Wait(1)
            CreateMarkers(0, boxPickup.x, boxPickup.y, boxPickup.z, "blue")
            playerCoords = GetEntityCoords(playerPed)
            if not OnMission then
                return
            end
        end

        PickupBox(boxPickup)

        WaypointerCreate("warehouse_job_box_dropoff_" .. i, boxDropoff, nil, 1, false, 5, "Box Dropoff", true, true, true)
        table.insert(WaypointsForMission, "warehouse_job_box_dropoff_" .. i)

        while #(playerCoords - vector3(boxDropoff.x, boxDropoff.y, boxDropoff.z)) > 1.0 do
            Citizen.Wait(1)
            CreateMarkers(0, boxDropoff.x, boxDropoff.y, boxDropoff.z, "green")
            playerCoords = GetEntityCoords(playerPed)
            if not OnMission then
                return
            end
        end

        DropBox(boxDropoff)
    end

    TriggerEvent("notification:send", {text = "You have completed the job. Return to the foreman to get paid.", color = "green", time = 7000})

    ChanceToStealItemFunc()

    while #(playerCoords - vector3(npcBlip[1].x, npcBlip[1].y, npcBlip[1].z)) > 3.0 do
        Citizen.Wait(10)
        playerCoords = GetEntityCoords(playerPed)
    end

    OnMission = false
    GettingPaid()
    RemoveAllWaypoints()
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        local playerPed = GetPlayerPed(-1)
        local playerCoords = GetEntityCoords(playerPed)
        local distance = #(playerCoords - vector3(npcBlip[1].x, npcBlip[1].y, npcBlip[1].z))

        local warehouseData = json.decode(GetExternalKvpString("save-load", "WAREHOUSE_DATA"))

        if distance < 2.0 and MenuDisplay == false and not IsPedInAnyVehicle(playerPed, false) then
            if OnMission == false then
                MenuDisplay = true
                TriggerEvent("side-menu:addOptions", {
                    {id = "warehouse_job_jobs", label = "Number of Jobs:", quantity = tostring(warehouseData.jobs)},
                    {id = "warehouse_job_level", label = "Job Level:", quantity = tostring(warehouseData.level)},
                    {id = "warehouse_job_start_job", label = "Start Job", cb = function()
                        CloseAllMenus(0, true)
                        StartMission()
                    end}
                }) 
            else
                MenuDisplay = true
                TriggerEvent("side-menu:addOptions", {
                    {id = "warehouse_job_cancel_mision", label = "Cancel Mission", cb = function()
                        CloseAllMenus(0, true)
                        RemoveAllWaypoints()
                        OnMission = false
                    end}
                })
            end
            
        elseif distance > 2.0 and distance <= 3.0 then
            CloseAllMenus()
        end
    end
end)