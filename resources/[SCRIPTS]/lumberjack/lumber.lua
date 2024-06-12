local npc_blip = {
    {x = -560.9688, y = 5351.5479, z = 69.2223, h = 69.0079}
}

--create the tree cords without heading

local trees = {
    {blip = nil, treeOBJ = nil, x = -646.4113, y = 5258.2148, z = 75.2900},
    {blip = nil, treeOBJ = nil, x = -664.8446, y = 5267.7358, z = 76.0087},
    {blip = nil, treeOBJ = nil, x = -679.9406, y = 5263.9971, z = 76.6440},
    {blip = nil, treeOBJ = nil, x = -631.4731, y = 5244.8062, z = 74.3078},
    {blip = nil, treeOBJ = nil, x = -618.1598, y = 5247.0020, z = 72.7108},
    {blip = nil, treeOBJ = nil, x = -614.6541, y = 5233.7979, z = 73.5117}
}

-- create the car spawn coords

local car = {
    {x = -566.9289, y = 5353.4385, z = 69.7998, h = 159.2364}
}

local deliverCar = {
    {x = -567.6115, y = 5352.5845, z = 69.7795, h = 164.1823}
}


-- create the lumberjack blip

Citizen.CreateThread(function()

    for k,v in ipairs(npc_blip) do
        local blip = AddBlipForCoord(v.x, v.y, v.z)
        SetBlipSprite(blip, 652)
        SetBlipColour(blip, 1)
        SetBlipScale(blip, 0.8)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Lumberjack Job")
        EndTextCommandSetBlipName(blip)

        -- spawn the NPC to start the job

        local hash = GetHashKey("s_m_m_lathandy_01")
        while not HasModelLoaded(hash) do
            RequestModel(hash)
            Wait(20)
        end
        
        -- spawn the npc at x = -560.9688, y = 5351.5479, z = 70.2223, h = 69.0079

        ped = CreatePed("PED_TYPE_CIVMALE", "s_m_m_lathandy_01", v.x, v.y, v.z, v.h, false, false)
        -- Set NPC invincible, unkillable and frozen
        SetEntityInvincible(ped, true)
        FreezeEntityPosition(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
    end
end)


function CloseAllMenus(cooldown, stay)
    Citizen.CreateThread(function()   
        if cooldown then
            Citizen.Wait(cooldown)
        end

        if stay then

        else
            menuOpen = false
        end
    end)

    TriggerEvent("side-menu:resetOptions")
end


local isLumberjack = false
local isCarSpawned = false
local MenuDisplay = false
local numTreesCut = 0
local currentVehicle = nil


function Mission()

    isLumberjack = true

    TreesSpawner()
    VehicleSpawner()
    while true do
        if numTreesCut < #trees then
            CuttingTrees() 
        elseif numTreesCut == #trees then
            DeliverCar()
            GettingPaid()
            ResetJob()
            break
        end 
    end
end

function TreesSpawner()
    
    -- Create blips for all trees and make them visible. Should be able to delete the blips after the tree is cut down

    for k,v in ipairs(trees) do
        v.blip = AddBlipForCoord(v.x, v.y, v.z)
        SetBlipSprite(v.blip, 836)
        SetBlipColour(v.blip, 0)
        SetBlipScale(v.blip, 0.8)
        SetBlipAsShortRange(v.blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Tree")
        EndTextCommandSetBlipName(v.blip)
    end

    -- spawn the trees

    for k,v in ipairs(trees) do
        local hash = GetHashKey("prop_tree_fallen_pine_01")
        while not HasModelLoaded(hash) do
            RequestModel(hash)
            Wait(20)
        end

        v.treeOBJ = CreateObject(hash, v.x, v.y, v.z - 1, true, true, true)
        SetEntityAsMissionEntity(v.treeOBJ, true, true)
        FreezeEntityPosition(v.treeOBJ, true)
    end
end

function VehicleSpawner()
    if isCarSpawned == false then
        local hash = GetHashKey("bison")
        while not HasModelLoaded(hash) do
            RequestModel(hash)
            Wait(20)
        end

        currentVehicle = CreateVehicle(hash, car[1].x, car[1].y, car[1].z, car[1].h, true, true)
        SetVehicleNumberPlateText(currentVehicle, "LUMBER")
        SetVehicleOnGroundProperly(currentVehicle)
        SetEntityAsMissionEntity(currentVehicle, true, true)
        TaskWarpPedIntoVehicle(playerPed, currentVehicle, -1)
        isCarSpawned = true
    end
end

function CuttingTrees()
    local cutTrees = 0

    while true do
        -- code inside the while loop
        Citizen.Wait(10)
        local playerPed = GetPlayerPed(-1)
        local playerCoords = GetEntityCoords(playerPed)

        for k, v in ipairs(trees) do
            local treeCoords = GetEntityCoords(v.treeOBJ)
            local distance = #(playerCoords - treeCoords)

            if distance < 2.0 then
                FreezeEntityPosition(playerPed, true)
                local axeHash = -102973651
                GiveWeaponToPed(playerPed, axeHash, 1, false, true)
                SetCurrentPedWeapon(playerPed, axeHash, true)

                RequestAnimDict("melee@hatchet@streamed_core") -- Animation dictionary
                while not HasAnimDictLoaded("melee@hatchet@streamed_core") do
                    Citizen.Wait(100)
                end

                TaskPlayAnim(playerPed, 'melee@hatchet@streamed_core', 'plyr_front_takedown', 4.0, -8, 0.01, 0, 0, 0, 0, 0)
                
                Citizen.Wait(3000)

                ClearPedTasks(playerPed)

                RemoveWeaponFromPed(playerPed, axeHash)

                FreezeEntityPosition(playerPed, false)

                numTreesCut = numTreesCut + 1
                DeleteEntity(v.treeOBJ)
                RemoveBlip(v.blip)
                cutTrees = cutTrees + 1
            end
        end

        if cutTrees == #trees then
            break
        end
    end
end

function DeliverCar()
    local playerPed = GetPlayerPed(-1)

    TriggerEvent("notification:send", {time = 5000, color = "blue", text = "Deliver the vehicle to the boss."})

    TriggerEvent("waypointer:add", 
        "deliver-lumber-vehicle", --waypointer name
        {
            coords = deliverCar[1], 
            entity = nil, -- No need to set coords when using entities
            sprite = 1, scale = 0.5, 
            short = true, 
            color = 46, 
            label = "Destination"
        }, 
        {
            coords = deliverCar[1], -- No need to set coords when using entities
            color = 46, 
            onFoot = false, 
            radarThick = 16, 
            mapThick = 16, 
            range = 30, 
            removeBlip = true
        }
    )
    
    while true do
        Citizen.Wait(10)
        local playerCoords = GetEntityCoords(playerPed)
        local distance = #(playerCoords - vector3(deliverCar[1].x, deliverCar[1].y, deliverCar[1].z))
        if distance < 5.0 then
            isLumberjack = false
            numTreesCut = 0
            SetVehicleBrake(currentVehicle, true)
            Citizen.Wait(1000)
            DeleteVehicle(currentVehicle)
            TriggerEvent("notification:send", {time = 5000, color = "green", text = "Car has been delivered."})
            break
        end
    end
end

function GettingPaid()
    local lumberData = json.decode(GetExternalKvpString("save-load", "LUMBER_DATA"))
    local payment = math.random(1000, 2000)
    payment = math.floor(payment + (payment * (lumberData.level / 10)))
    TriggerEvent("notification:send", {time = 5000, color = "green", text = "You have been paid $" .. payment})
    TriggerEvent("bank:changeBank", payment)
    lumberData.jobs = lumberData.jobs + 1
    if lumberData.level < 10 and lumberData.jobs <= 100 then
        lumberData.level = math.floor(lumberData.jobs / 10)
        if lumberData.level == 100 then
            TriggerEvent('notification:center', {time = 5000, text = "You reached max level."})
            lumberData.canBuy = true
        end
    end
    TriggerEvent("save-load:setGlobalVariables", {{name = "LUMBER_DATA", type = "string", value = json.encode(lumberData)}})
end

function ResetJob()
    isLumberjack = false
    numTreesCut = 0
    DeleteVehicle(currentVehicle)
    currentVehicle = nil
    isCarSpawned = false
    for i in ipairs(trees) do
        DeleteEntity(trees[i].treeOBJ)
        RemoveBlip(trees[i].blip)
        trees[i].treeOBJ = nil
        trees[i].blip = nil
    end
end



Citizen.CreateThread(function()

    while true do
        Citizen.Wait(10)
        playerPed = GetPlayerPed(-1)
        playerCoords = GetEntityCoords(playerPed)
        distance = GetDistanceBetweenCoords(playerCoords, npc_blip[1].x, npc_blip[1].y, npc_blip[1].z, true)

        if distance < 2.0 and MenuDisplay == false then
            local lumberData = json.decode(GetExternalKvpString("save-load", "LUMBER_DATA"))
            MenuDisplay = true
            TriggerEvent("side-menu:addOptions", {
                {id = "LUMBER_JOB_JOBS", label = "Number of Jobs:", quantity = tostring(lumberData.jobs)},
                {id = "LUMBER_JOB_LEVEL", label = "Level:", quantity = tostring(lumberData.level)},
            })

            if isLumberjack == false then
                TriggerEvent("side-menu:addOptions", {
                    {id = "LUMBER_JOB_START_JOB", label = "Start Job", cb = function()
                        Mission()
                        CloseAllMenus()
                    end}
                })
            elseif isLumberjack == true then    
                TriggerEvent("side-menu:addOptions", {
                    {id = "LUMBER_JOB_END_JOB", label = "End Job", cb = function()
                        isLumberjack = false
                        numTreesCut = 0
                        DeleteVehicle(currentVehicle)
                        currentVehicle = nil
                        isCarSpawned = false
                        for i, t in ipairs(trees) do
                            DeleteEntity(t.treeOBJ)
                            RemoveBlip(t.blip)
                            t.treeOBJ = nil
                            t.blip = nil
                        end
                        CloseAllMenus()
                    end}
                })
            end

        elseif distance > 2.0 and MenuDisplay == true then
            MenuDisplay = false
            CloseAllMenus()
        end
    end
end)