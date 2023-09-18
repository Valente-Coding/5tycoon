local warehouseMissionState = 0
local carryingBox = false
local menuDisplay = false
local blipJob = nil
local missionsMade = 0
local maxMissions = 2
local currentPickup = nil
local currentDelivery = nil
local boxObject = nil




local warehouseLocations = {
    {
        coords = vector4(152.6127, -3092.4675, 5.8963, 89.3102),
        ped = nil,
        pickupBoxesLocations = {
            vector3(137.0742, -3100.2688, 5.8955),
            vector3(139.5392, -3102.3745, 5.8963),
            vector3(138.5618, -3111.3069, 5.8963),
            vector3(151.3942, -3099.5686, 5.8963),
            vector3(134.7071, -3111.3042, 5.8963),
            vector3(130.6303, -3110.5508, 5.8963),
            vector3(122.1661, -3111.8899, 5.9960),
            vector3(121.9690, -3108.6843, 5.9988)
        },
        putDownBoxesLocations = {
            vector3(129.4729, -3079.4399, 5.9038),
            vector3(126.4441, -3074.7095, 5.9414),
            vector3(143.5693, -3074.8318, 5.8963)
        }
    },
}




Citizen.CreateThread(function()
    local blips = {}

    for _, location in pairs(warehouseLocations) do
        local blip = AddBlipForCoord(location.coords.x, location.coords.y, location.coords.z)
        SetBlipSprite(blip, 568)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.8)
        SetBlipColour(blip, 54)
        SetBlipAsShortRange(blip, false)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Warehouse Job")
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




function GetRandomPickupPoint()

    local pickRandom = math.random(1, #currentDepot.pickupBoxesLocations)

    local selectedPickupPoint = currentDepot.pickupBoxesLocations[pickRandom]

    return selectedPickupPoint

end




function GetRandomDeliveryPoint()

    local pickRandom = math.random(1, #currentDepot.putDownBoxesLocations)

    local selectedDeliveryPoint = currentDepot.putDownBoxesLocations[pickRandom]

    return selectedDeliveryPoint

end




function pickupBoxAnim(coords)

    SetEntityCoords(playerPed, coords.x, coords.y, coords.z, true, true, true, false)

    TaskPlayAnim(playerPed, "anim@heists@box_carry@", "idle", 8.0, -8.0, -1, 49, 0, false, false, false)

    carryingBox = true

end




function DropBox()

    DetachEntity(boxObject, true, true)
    DeleteEntity(boxObject)
    boxObject = nil

end




function NewWaypoint(coords)
    RemoveBlip(blipJob)
    blipJob = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipRoute(blipJob, true)
    SetBlipRouteColour(blipJob, 5)
    SetBlipSprite(blipJob, 1)
    SetBlipDisplay(blipJob, 2)
    SetBlipScale(blipJob, 0.5)
    SetBlipColour(blipJob, 5)
    SetBlipAsShortRange(blipJob, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Boxes")
    EndTextCommandSetBlipName(blipJob)
end


function CarryBox()

    local playerPed = GetPlayerPed(-1)

    local boxModel = GetHashKey("prop_cs_cardbox_01")
    print(boxModel)

    RequestModel(boxModel)

    while not HasModelLoaded(boxModel) do
        Wait(1)
    end

    local boneIndex = GetPedBoneIndex(playerPed, 28422)
    local coordsForBoxHand = GetWorldPositionOfEntityBone(playerPed, boneIndex)
    boxObject = CreateObject(boxModel, coordsForBoxHand.x, coordsForBoxHand.y, coordsForBoxHand.z, true, true, true)
    AttachEntityToEntity(boxObject, playerPed, boneIndex, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)

end



Citizen.CreateThread(function()

    while true do

        Citizen.Wait(1)

        local playerPed = GetPlayerPed(-1)

        for _, depots in pairs(warehouseLocations) do
            TaskSetBlockingOfNonTemporaryEvents(depots.ped, true)
            FreezeEntityPosition(depots.ped, true)

            local pedCoords = GetEntityCoords(playerPed)
            local distance = #(pedCoords - vector3(depots.coords.x, depots.coords.y, depots.coords.z))

            if distance < 2 and currentDepot == nil then
                
                if menuDisplay == false then
                    menuDisplay = true
                
                    TriggerEvent("side-menu:addOptions", {{id = "warehouse_start_job", label = "Start Job", cb = function()
                        currentDepot = depots
                        currentPickup = GetRandomPickupPoint()
                        NewWaypoint(currentPickup)
                        TriggerEvent("side-menu:removeOptions", {{id = "warehouse_start_job"}})
                    end}})
                
                end
                
            else

                if menuDisplay == true then
                    menuDisplay = false

                    TriggerEvent("side-menu:removeOptions", {{id = "warehouse_start_job"}})

                end
            
            end

        end



        if currentDepot and currentPickup == nil and currentDelivery == nil and missionsMade < maxMissions then

            currentPickup = GetRandomPickupPoint()
    
        elseif missionsMade == maxMissions then

            DropBox()
            local payment = math.random(1500, 3000)
            local warehouseData = json.decode(GetExternalKvpString("save-load", "WAREHOUSE_DATA"))
            payment = math.floor(payment + (payment * (warehouseData.level / 5)))
            warehouseData.jobs = warehouseData.jobs + 1

            if warehouseData.level < 5 then

                warehouseData.level = math.floor(warehouseData.jobs / 5)

                if warehouseData.level == 5 then

                    warehouseData.canBuy = true

                end

            end

            TriggerEvent("save-load:updateData", {{name = "WAREHOUSE_DATA", type = "string", value = json.encode(warehouseData)}})
            TriggerEvent("bank:changeBank", payment)

            currentDelivery = nil
            currentDepot = nil
            currentMission = nil
            currentPickup = nil
            missionsMade = 0
        
        end
    
    
    
        if currentDepot and currentPickup and currentDelivery == nil then
    
            pedCoords = GetEntityCoords(playerPed)
            distance = #(pedCoords - currentPickup)
            
            if distance < 50 then
    
                DrawMarker(25, currentPickup.x, currentPickup.y, currentPickup.z - 0.8, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, false, false, false, true, false, false, false)
                DrawMarker(20, currentPickup.x, currentPickup.y, currentPickup.z, 0, 0, 0, 0, 180.0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, true, false, false, true, false, false, false)
    
                if distance < 2 then
                    
                    CarryBox()
                    currentDelivery = GetRandomDeliveryPoint()
                    pickupBoxAnim(vector4(currentPickup.x, currentPickup.y, currentPickup.z, 180.0))
                    currentPickup = nil
    
                end
    
            end
        
        end
    
        if currentDepot and currentDelivery then
    
            pedCoords = GetEntityCoords(playerPed)
            distance = #(pedCoords - currentDelivery)
    
            if distance < 50 then
    
                DrawMarker(25, currentDelivery.x, currentDelivery.y, currentDelivery.z - 0.8, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, false, false, false, true, false, false, false)
                DrawMarker(20, currentDelivery.x, currentDelivery.y, currentDelivery.z, 0, 0, 0, 0, 180.0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, true, false, false, true, false, false, false)
    
                if distance < 2 then
    
                    currentDelivery = nil
                    DropBox()
                    missionsMade = missionsMade + 1
    
                end
    
            end
    
        end

    end

end)