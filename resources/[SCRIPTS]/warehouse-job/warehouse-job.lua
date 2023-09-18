local warehouseMissionState = 0
local playerPed = GetPlayerPed(-1)
local carryingBox = false
local menuDisplay = false
local destination = nil
local blipJob = nil




local warehouseLocations = {
    {
        coords = vector4(152.6127, -3092.4675, 5.8963, 89.3102),
        ped = nil
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
    }
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

    local selectedPickupPoint = math.random(#warehouseLocations.pickupBoxesLocations)

    return selectedPickupPoint

end




function GetRandomDeliveryPoint()

    local selectedDeliveryPoint = math.random(#warehouseLocations.putDownBoxesLocations)

    return selectedDeliveryPoint

end




function pickupBoxAnim(coords)

    SetEntityCoords(playerPed, coords.x, coords.y, coords.z, true, true, true, false)

    TaskPlayAnim(playerPed, "anim@heists@box_carry@", "idle", 8.0, -8.0, -1, 49, 0, false, false, false)

    carryingBox = true

end




function DropBox()

    carryingBox = false

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




Citizen.CreateThread(function()
    
    while true do
        Citizen.Wait(1)

        if carryingBox then

            local boxModel = GetHashKey("prop_box_small")
            RequestModel(GetHashKey(boxModel))
            while not HasModelLoaded(boxModel) do
                Wait(1)
            end

            local boneIndex = GetPedBoneIndex(playerPed, 28422)
            local coordsForBoxHand = GetWorldPositionOfEntityBone(playerPed, boneIndex)
            local boxObject = CreateObject(boxModel, coordsForBoxHand.x, coordsForBoxHand.y, coordsForBoxHand.z, true, true, true)
            AttachEntityToEntity(boxObject, playerPed, boneIndex, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)

        else

            DetachEntity(boxObject, true, true)
            DeleteEntity(boxObject)
        
        end

    end

end)




Citizen.CreateThread(function()

    while true do

        Citizen.Wait(1)

        local pedCoords = GetEntityCoords(playerPed)
        local distance = #(pedCoords - vector3(warehouseLocations.coords.x, warehouseLocations.coords.y, warehouseLocations.coords.z))

        for _, depots in pairs(warehouseLocations) do
            TaskSetBlockingOfNonTemporaryEvents(depots.ped, true)
            FreezeEntityPosition(depots.ped, true)

            if distance < 2 and warehouseMissionState == 0 then
                menuDisplay = true
                
                TriggerEvent("side-menu:addOptions", {{id = "warehouse_start_job", label = "Start Job", cb = function()
                    warehouseMissionState = 1
                    destination = GetRandomPickupPoint()
                    currentDepot = depots
                    TriggerEvent("side-menu:removeOptions", {{id = "warehouse_start_job"}})
                end}})
                
            else

                if menuDisplay == true then
                    menuDisplay = false

                    TriggerEvent("side-menu:removeOptions", {{id = "warehouse_start_job"}})

                end
            
            end

        end

        pedCoords = GetEntityCoords(playerPed)
        distance = #(pedCoords - vector3(destination.x, destination.y, destination.z))
        NewWaypoint(destination)

        if distance < 50 then
            
            DrawMarker(25, destination.x, destination.y, destination.z - 0.8, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, false, false, false, true, false, false, false)
            DrawMarker(20, destination.x, destination.y, destination.z, 0, 0, 0, 0, 180.0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, true, false, false, true, false, false, false)
        
            if distance < 2 and warehouseMissionState == 1 then

                pickupBoxAnim()
                destination = nil
                RemoveBlip(blipJob)

            end

        end

        destination = GetRandomDeliveryPoint()
        pedCoords = GetEntityCoords(playerPed)
        distance = #(pedCoords - vector3(destination.x, destination.y, destination.z))
        NewWaypoint(destination)

        if distance < 50 then

            DrawMarker(25, destination.x, destination.y, destination.z - 0.8, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, false, false, false, true, false, false, false)
            DrawMarker(20, destination.x, destination.y, destination.z, 0, 0, 0, 0, 180.0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, true, false, false, true, false, false, false)

            if distance < 2 warehouseMissionState == 1 then

                warehouseMissionState = 2
                DropBox()
                destination = nil
                RemoveBlip(blipJob)
                destination = GetRandomPickupPoint()
            
            end

        end

        pedCoords = GetEntityCoords(playerPed)
        distance = #(pedCoords - vector3(destination.x, destination.y, destination.z))
        NewWaypoint(destination)

        if distance < 50 then
            
            DrawMarker(25, destination.x, destination.y, destination.z - 0.8, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, false, false, false, true, false, false, false)
            DrawMarker(20, destination.x, destination.y, destination.z, 0, 0, 0, 0, 180.0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, true, false, false, true, false, false, false)
        
            if distance < 2 and warehouseMissionState == 2 then

                pickupBoxAnim()
                destination = nil
                RemoveBlip(blipJob)

            end

        end

        destination = GetRandomDeliveryPoint()
        pedCoords = GetEntityCoords(playerPed)
        distance = #(pedCoords - vector3(destination.x, destination.y, destination.z))
        NewWaypoint(destination)

        if distance < 50 then

            DrawMarker(25, destination.x, destination.y, destination.z - 0.8, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, false, false, false, true, false, false, false)
            DrawMarker(20, destination.x, destination.y, destination.z, 0, 0, 0, 0, 180.0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, true, false, false, true, false, false, false)

            if distance < 2 warehouseMissionState == 2 then

                warehouseMissionState = 3
                DropBox()
                destination = nil
                RemoveBlip(blipJob)
                destination = GetRandomPickupPoint()
            
            end

        end

        pedCoords = GetEntityCoords(playerPed)
        distance = #(pedCoords - vector3(destination.x, destination.y, destination.z))
        NewWaypoint(destination)

        if distance < 50 then
            
            DrawMarker(25, destination.x, destination.y, destination.z - 0.8, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, false, false, false, true, false, false, false)
            DrawMarker(20, destination.x, destination.y, destination.z, 0, 0, 0, 0, 180.0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, true, false, false, true, false, false, false)
        
            if distance < 2 and warehouseMissionState == 3 then

                pickupBoxAnim()
                destination = nil
                RemoveBlip(blipJob)

            end

        end

        destination = GetRandomDeliveryPoint()
        pedCoords = GetEntityCoords(playerPed)
        distance = #(pedCoords - vector3(destination.x, destination.y, destination.z))
        NewWaypoint(destination)

        if distance < 50 then

            DrawMarker(25, destination.x, destination.y, destination.z - 0.8, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, false, false, false, true, false, false, false)
            DrawMarker(20, destination.x, destination.y, destination.z, 0, 0, 0, 0, 180.0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, true, false, false, true, false, false, false)

            if distance < 2 warehouseMissionState == 3 then

                warehouseMissionState = 4
                DropBox()
                destination = nil
                RemoveBlip(blipJob)
                destination = GetRandomPickupPoint()
            
            end

        end

        pedCoords = GetEntityCoords(playerPed)
        distance = #(pedCoords - vector3(destination.x, destination.y, destination.z))
        NewWaypoint(destination)

        if distance < 50 then
            
            DrawMarker(25, destination.x, destination.y, destination.z - 0.8, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, false, false, false, true, false, false, false)
            DrawMarker(20, destination.x, destination.y, destination.z, 0, 0, 0, 0, 180.0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, true, false, false, true, false, false, false)
        
            if distance < 2 and warehouseMissionState == 4 then

                pickupBoxAnim()
                destination = nil
                RemoveBlip(blipJob)

            end

        end

        destination = GetRandomDeliveryPoint()
        pedCoords = GetEntityCoords(playerPed)
        distance = #(pedCoords - vector3(destination.x, destination.y, destination.z))
        NewWaypoint(destination)

        if distance < 50 then

            DrawMarker(25, destination.x, destination.y, destination.z - 0.8, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, false, false, false, true, false, false, false)
            DrawMarker(20, destination.x, destination.y, destination.z, 0, 0, 0, 0, 180.0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, true, false, false, true, false, false, false)

            if distance < 2 warehouseMissionState == 4 then

                warehouseMissionState = 5
                DropBox()
                destination = nil
                RemoveBlip(blipJob)
                destination = GetRandomPickupPoint()
            
            end

        end

        pedCoords = GetEntityCoords(playerPed)
        distance = #(pedCoords - vector3(destination.x, destination.y, destination.z))
        NewWaypoint(destination)

        if distance < 50 then
            
            DrawMarker(25, destination.x, destination.y, destination.z - 0.8, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, false, false, false, true, false, false, false)
            DrawMarker(20, destination.x, destination.y, destination.z, 0, 0, 0, 0, 180.0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, true, false, false, true, false, false, false)
        
            if distance < 2 and warehouseMissionState == 5 then

                pickupBoxAnim()
                destination = nil
                RemoveBlip(blipJob)

            end

        end

        destination = GetRandomDeliveryPoint()
        pedCoords = GetEntityCoords(playerPed)
        distance = #(pedCoords - vector3(destination.x, destination.y, destination.z))
        NewWaypoint(destination)

        if distance < 50 then

            DrawMarker(25, destination.x, destination.y, destination.z - 0.8, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, false, false, false, true, false, false, false)
            DrawMarker(20, destination.x, destination.y, destination.z, 0, 0, 0, 0, 180.0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, true, false, false, true, false, false, false)

            if distance < 2 warehouseMissionState == 5 then

                warehouseMissionState = 6
                DropBox()
                destination = nil
                RemoveBlip(blipJob)
                destination = GetRandomPickupPoint()
            
            end

        end

        pedCoords = GetEntityCoords(playerPed)
        distance = #(pedCoords - vector3(destination.x, destination.y, destination.z))
        NewWaypoint(destination)

        if distance < 50 then
            
            DrawMarker(25, destination.x, destination.y, destination.z - 0.8, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, false, false, false, true, false, false, false)
            DrawMarker(20, destination.x, destination.y, destination.z, 0, 0, 0, 0, 180.0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, true, false, false, true, false, false, false)
        
            if distance < 2 and warehouseMissionState == 6 then

                pickupBoxAnim()
                destination = nil
                RemoveBlip(blipJob)

            end

        end

        destination = GetRandomDeliveryPoint()
        pedCoords = GetEntityCoords(playerPed)
        distance = #(pedCoords - vector3(destination.x, destination.y, destination.z))
        NewWaypoint(destination)

        if distance < 50 then

            DrawMarker(25, destination.x, destination.y, destination.z - 0.8, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, false, false, false, true, false, false, false)
            DrawMarker(20, destination.x, destination.y, destination.z, 0, 0, 0, 0, 180.0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, true, false, false, true, false, false, false)

            if distance < 2 warehouseMissionState == 6 then

                warehouseMissionState = 7
                DropBox()
                destination = nil
                RemoveBlip(blipJob)
                destination = GetRandomPickupPoint()
            
            end

        end

        pedCoords = GetEntityCoords(playerPed)
        distance = #(pedCoords - vector3(destination.x, destination.y, destination.z))
        NewWaypoint(destination)

        if distance < 50 then
            
            DrawMarker(25, destination.x, destination.y, destination.z - 0.8, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, false, false, false, true, false, false, false)
            DrawMarker(20, destination.x, destination.y, destination.z, 0, 0, 0, 0, 180.0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, true, false, false, true, false, false, false)
        
            if distance < 2 and warehouseMissionState == 7 then

                pickupBoxAnim()
                destination = nil
                RemoveBlip(blipJob)

            end

        end

        destination = GetRandomDeliveryPoint()
        pedCoords = GetEntityCoords(playerPed)
        distance = #(pedCoords - vector3(destination.x, destination.y, destination.z))
        NewWaypoint(destination)

        if distance < 50 then

            DrawMarker(25, destination.x, destination.y, destination.z - 0.8, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, false, false, false, true, false, false, false)
            DrawMarker(20, destination.x, destination.y, destination.z, 0, 0, 0, 0, 180.0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, true, false, false, true, false, false, false)

            if distance < 2 warehouseMissionState == 7 then

                warehouseMissionState = 8
                DropBox()
                destination = nil
                RemoveBlip(blipJob)
                destination = GetRandomPickupPoint()
            
            end

        end

        pedCoords = GetEntityCoords(playerPed)
        distance = #(pedCoords - vector3(destination.x, destination.y, destination.z))
        NewWaypoint(destination)

        if distance < 50 then
            
            DrawMarker(25, destination.x, destination.y, destination.z - 0.8, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, false, false, false, true, false, false, false)
            DrawMarker(20, destination.x, destination.y, destination.z, 0, 0, 0, 0, 180.0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, true, false, false, true, false, false, false)
        
            if distance < 2 and warehouseMissionState == 8 then

                pickupBoxAnim()
                destination = nil
                RemoveBlip(blipJob)

            end

        end

        destination = GetRandomDeliveryPoint()
        pedCoords = GetEntityCoords(playerPed)
        distance = #(pedCoords - vector3(destination.x, destination.y, destination.z))
        NewWaypoint(destination)

        if distance < 50 then

            DrawMarker(25, destination.x, destination.y, destination.z - 0.8, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, false, false, false, true, false, false, false)
            DrawMarker(20, destination.x, destination.y, destination.z, 0, 0, 0, 0, 180.0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, true, false, false, true, false, false, false)

            if distance < 2 warehouseMissionState == 8 then

                warehouseMissionState = 9
                DropBox()
                destination = nil
                RemoveBlip(blipJob)
                destination = GetRandomPickupPoint()
            
            end

        end

        pedCoords = GetEntityCoords(playerPed)
        distance = #(pedCoords - vector3(destination.x, destination.y, destination.z))
        NewWaypoint(destination)

        if distance < 50 then
            
            DrawMarker(25, destination.x, destination.y, destination.z - 0.8, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, false, false, false, true, false, false, false)
            DrawMarker(20, destination.x, destination.y, destination.z, 0, 0, 0, 0, 180.0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, true, false, false, true, false, false, false)
        
            if distance < 2 and warehouseMissionState == 9 then

                pickupBoxAnim()
                destination = nil
                RemoveBlip(blipJob)

            end

        end

        destination = GetRandomDeliveryPoint()
        pedCoords = GetEntityCoords(playerPed)
        distance = #(pedCoords - vector3(destination.x, destination.y, destination.z))
        NewWaypoint(destination)

        if distance < 50 then

            DrawMarker(25, destination.x, destination.y, destination.z - 0.8, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, false, false, false, true, false, false, false)
            DrawMarker(20, destination.x, destination.y, destination.z, 0, 0, 0, 0, 180.0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, true, false, false, true, false, false, false)

            if distance < 2 warehouseMissionState == 9 then

                warehouseMissionState = 10
                DropBox()
                destination = nil
                RemoveBlip(blipJob)
                destination = GetRandomPickupPoint()
            
            end

        end

        pedCoords = GetEntityCoords(playerPed)
        distance = #(pedCoords - vector3(destination.x, destination.y, destination.z))
        NewWaypoint(destination)

        if distance < 50 then
            
            DrawMarker(25, destination.x, destination.y, destination.z - 0.8, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, false, false, false, true, false, false, false)
            DrawMarker(20, destination.x, destination.y, destination.z, 0, 0, 0, 0, 180.0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, true, false, false, true, false, false, false)
        
            if distance < 2 and warehouseMissionState == 10 then

                pickupBoxAnim()
                destination = nil
                RemoveBlip(blipJob)

            end

        end

        destination = GetRandomDeliveryPoint()
        pedCoords = GetEntityCoords(playerPed)
        distance = #(pedCoords - vector3(destination.x, destination.y, destination.z))
        NewWaypoint(destination)

        if distance < 50 then

            DrawMarker(25, destination.x, destination.y, destination.z - 0.8, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, false, false, false, true, false, false, false)
            DrawMarker(20, destination.x, destination.y, destination.z, 0, 0, 0, 0, 180.0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, true, false, false, true, false, false, false)

            if distance < 2 warehouseMissionState == 10 then

                warehouseMissionState = 11
                DropBox()
                destination = nil
                RemoveBlip(blipJob)
                destination = GetRandomPickupPoint()
            
            end

        end

        pedCoords = GetEntityCoords(playerPed)
        distance = #(pedCoords - vector3(destination.x, destination.y, destination.z))
        NewWaypoint(destination)

        if distance < 50 then
            
            DrawMarker(25, destination.x, destination.y, destination.z - 0.8, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, false, false, false, true, false, false, false)
            DrawMarker(20, destination.x, destination.y, destination.z, 0, 0, 0, 0, 180.0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, true, false, false, true, false, false, false)
        
            if distance < 2 and warehouseMissionState == 11 then

                pickupBoxAnim()
                destination = nil
                RemoveBlip(blipJob)

            end

        end

        destination = GetRandomDeliveryPoint()
        pedCoords = GetEntityCoords(playerPed)
        distance = #(pedCoords - vector3(destination.x, destination.y, destination.z))
        NewWaypoint(destination)

        if distance < 50 then

            DrawMarker(25, destination.x, destination.y, destination.z - 0.8, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, false, false, false, true, false, false, false)
            DrawMarker(20, destination.x, destination.y, destination.z, 0, 0, 0, 0, 180.0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, true, false, false, true, false, false, false)

            if distance < 2 warehouseMissionState == 11 then

                warehouseMissionState = 12
                DropBox()
                destination = nil
                RemoveBlip(blipJob)
                destination = GetRandomPickupPoint()
            
            end

        end

        pedCoords = GetEntityCoords(playerPed)
        distance = #(pedCoords - vector3(destination.x, destination.y, destination.z))
        NewWaypoint(destination)

        if distance < 50 then
            
            DrawMarker(25, destination.x, destination.y, destination.z - 0.8, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, false, false, false, true, false, false, false)
            DrawMarker(20, destination.x, destination.y, destination.z, 0, 0, 0, 0, 180.0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, true, false, false, true, false, false, false)
        
            if distance < 2 and warehouseMissionState == 12 then

                pickupBoxAnim()
                destination = nil
                RemoveBlip(blipJob)

            end

        end

        destination = GetRandomDeliveryPoint()
        pedCoords = GetEntityCoords(playerPed)
        distance = #(pedCoords - vector3(destination.x, destination.y, destination.z))
        NewWaypoint(destination)

        if distance < 50 then

            DrawMarker(25, destination.x, destination.y, destination.z - 0.8, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, false, false, false, true, false, false, false)
            DrawMarker(20, destination.x, destination.y, destination.z, 0, 0, 0, 0, 180.0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, true, false, false, true, false, false, false)

            if distance < 2 warehouseMissionState == 12 then

                warehouseMissionState = 13
                DropBox()
                destination = nil
                RemoveBlip(blipJob)
                destination = GetRandomPickupPoint()
            
            end

        end

        pedCoords = GetEntityCoords(playerPed)
        distance = #(pedCoords - vector3(destination.x, destination.y, destination.z))
        NewWaypoint(destination)

        if distance < 50 then
            
            DrawMarker(25, destination.x, destination.y, destination.z - 0.8, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, false, false, false, true, false, false, false)
            DrawMarker(20, destination.x, destination.y, destination.z, 0, 0, 0, 0, 180.0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, true, false, false, true, false, false, false)
        
            if distance < 2 and warehouseMissionState == 13 then

                pickupBoxAnim()
                destination = nil
                RemoveBlip(blipJob)

            end

        end

        destination = GetRandomDeliveryPoint()
        pedCoords = GetEntityCoords(playerPed)
        distance = #(pedCoords - vector3(destination.x, destination.y, destination.z))
        NewWaypoint(destination)

        if distance < 50 then

            DrawMarker(25, destination.x, destination.y, destination.z - 0.8, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, false, false, false, true, false, false, false)
            DrawMarker(20, destination.x, destination.y, destination.z, 0, 0, 0, 0, 180.0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, true, false, false, true, false, false, false)

            if distance < 2 warehouseMissionState == 13 then

                warehouseMissionState = 14
                DropBox()
                destination = nil
                RemoveBlip(blipJob)
                destination = GetRandomPickupPoint()
            
            end

        end

        pedCoords = GetEntityCoords(playerPed)
        distance = #(pedCoords - vector3(destination.x, destination.y, destination.z))
        NewWaypoint(destination)

        if distance < 50 then
            
            DrawMarker(25, destination.x, destination.y, destination.z - 0.8, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, false, false, false, true, false, false, false)
            DrawMarker(20, destination.x, destination.y, destination.z, 0, 0, 0, 0, 180.0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, true, false, false, true, false, false, false)
        
            if distance < 2 and warehouseMissionState == 14 then

                pickupBoxAnim()
                destination = nil
                RemoveBlip(blipJob)

            end

        end

        destination = GetRandomDeliveryPoint()
        pedCoords = GetEntityCoords(playerPed)
        distance = #(pedCoords - vector3(destination.x, destination.y, destination.z))
        NewWaypoint(destination)

        if distance < 50 then

            DrawMarker(25, destination.x, destination.y, destination.z - 0.8, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, false, false, false, true, false, false, false)
            DrawMarker(20, destination.x, destination.y, destination.z, 0, 0, 0, 0, 180.0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, true, false, false, true, false, false, false)

            if distance < 2 warehouseMissionState == 14 then

                warehouseMissionState = 15
                DropBox()
                destination = nil
                RemoveBlip(blipJob)
                destination = GetRandomPickupPoint()
            
            end

        end

        pedCoords = GetEntityCoords(playerPed)
        distance = #(pedCoords - vector3(destination.x, destination.y, destination.z))
        NewWaypoint(destination)

        if distance < 50 then
            
            DrawMarker(25, destination.x, destination.y, destination.z - 0.8, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, false, false, false, true, false, false, false)
            DrawMarker(20, destination.x, destination.y, destination.z, 0, 0, 0, 0, 180.0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, true, false, false, true, false, false, false)
        
            if distance < 2 and warehouseMissionState == 15 then

                pickupBoxAnim()
                destination = nil
                RemoveBlip(blipJob)

            end

        end

        destination = GetRandomDeliveryPoint()
        pedCoords = GetEntityCoords(playerPed)
        distance = #(pedCoords - vector3(destination.x, destination.y, destination.z))
        NewWaypoint(destination)

        if distance < 50 then

            DrawMarker(25, destination.x, destination.y, destination.z - 0.8, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, false, false, false, true, false, false, false)
            DrawMarker(20, destination.x, destination.y, destination.z, 0, 0, 0, 0, 180.0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, true, false, false, true, false, false, false)

            if distance < 2 warehouseMissionState == 15 then

                warehouseMissionState = 16
                DropBox()
                destination = nil
                RemoveBlip(blipJob)
            
            end

        end

        destination = currentDepot.coords
        pedCoords = GetEntityCoords(playerPed)
        distance = #(pedCoords - vector3(destination.x, destination.y, destination.z))
        NewWaypoint(destination)

        if distance < 50 then

            DrawMarker(25, destination.x, destination.y, destination.z - 0.8, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, false, false, false, true, false, false, false)
            DrawMarker(20, destination.x, destination.y, destination.z, 0, 0, 0, 0, 180.0, 0, 2.0, 2.0, 2.0, 255, 0, 0, 1.0, true, false, false, true, false, false, false)

            if distance < 2 and warehouseMissionState == 16 then

                distance = nil
                RemoveBlip(blipJob)
                warehouseMissionState = 0
                blipJob = nil
                local payment = math.random(1500, 3000)
                local deliveryData = json.decode(GetExternalKvpString("save-load", "WAREHOUSE_DATA"))
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

            end

        end

    end

end)