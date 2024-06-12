local pricePerMeter = 2
local destination = nil
local currentTaxiVeh = nil
local currentTaxiNpc = nil
local waitTime = 60000
local currentWaitingTime = 0

RegisterNetEvent("taxi:callTaxi")

function CallTaxi()
    local ped = GetPlayerPed(-1)

    if currentTaxiVeh ~= nil then TriggerEvent("notification:send", {color = "red", time = 7000, text = "A taxi is already on the way to you."}) return end
    if IsPedInAnyVehicle(ped) then TriggerEvent("notification:send", {color = "red", time = 7000, text = "You can't call a taxi while inside a vehicle."}) return end

    destination = GetBlipCoords(GetFirstBlipInfoId(8))
    
    if destination == vector3(0,0,0) then TriggerEvent("notification:send", {color = "red", time = 7000, text = "You need to set a waypoint first."}) return end
    DeleteWaypoint()

    if not HasMoney(ped) then return end
end

AddEventHandler("taxi:callTaxi", CallTaxi)

function HasMoney(ped)
    local distance = #(GetEntityCoords(ped) - destination)
    local price = pricePerMeter * distance

    TriggerEvent("bank:changeBank", -price, function(check, needAmount)
        if check then 
            TriggerEvent("notification:send", {color = "green", time = 7000, text = "A taxi is on the way to you."})
            PrepareTravel()
        else
            TriggerEvent("notification:send", {color = "red", time = 7000, text = "You don't have enought money to call a taxi. You need at least $"..needAmount})
        end
    end)
end

function PrepareTravel()
    local ped = GetPlayerPed(-1)
    SpawnTaxi(ped)

    WaitForConfirmation(ped)
end

function SpawnTaxi(ped)
    local pCoords = GetEntityCoords(ped)
    local streetCoords = GetClosestStreetCoords(pCoords.x - math.random(-200, 200), pCoords.y - math.random(-200, 200), pCoords.z)
    local vehModel = "taxi"
    local npcModel = "a_m_y_stlat_01"

    RequestModel(vehModel)
    while not HasModelLoaded(vehModel) do
        Citizen.Wait(100)
    end

    currentTaxiVeh = CreateVehicle(vehModel, streetCoords.x, streetCoords.y, streetCoords.z, streetCoords.w, true, false)

    AddTaxiBlip(currentTaxiVeh)

    RequestModel(npcModel)
    while not HasModelLoaded(npcModel) do
        Wait(0)
    end

    -- Create the ped inside the car
    currentTaxiNpc = CreatePedInsideVehicle(currentTaxiVeh, 26, npcModel, -1, true, false)
    SetModelAsNoLongerNeeded(currentTaxiVeh)

    SetBlockingOfNonTemporaryEvents(currentTaxiNpc, true)
    SetEntityAsMissionEntity(currentTaxiNpc, true, true)
    SetEntityInvincible(currentTaxiNpc, true)

    SetVehicleOnGroundProperly(currentTaxiVeh)
    SetEntityAsMissionEntity(currentTaxiVeh, true, true)
    SetVehicleEngineOn(currentTaxiVeh, true, true, false)

    SetDriveTaskDrivingStyle(currentTaxiNpc, 1074528293)

    local closestPedStreet = GetClosestStreetCoords(pCoords.x, pCoords.y, pCoords.z)
    TaskVehicleDriveToCoord(currentTaxiNpc, currentTaxiVeh, closestPedStreet.x, closestPedStreet.y, closestPedStreet.z, 26.0, 0, GetHashKey(vehModel), 411, 10.0)
    SetPedKeepTask(currentTaxiNpc, true)
end

function AddTaxiBlip(veh)
    local plate = GetVehicleNumberPlateText(veh)

    TriggerEvent("waypointer:add", 
        "taxi-"..plate, --waypointer name
        {
            coords = nil, 
            entity = veh, -- No need to set coords when using entities
            sprite = 198, scale = 0.7, 
            short = true, 
            color = 28, 
            label = "Taxi"
        }, 
        {
            coords = nil, -- No need to set coords when using entities
            color = 28, 
            onFoot = true, 
            radarThick = 16, 
            mapThick = 16, 
            range = 30, 
            removeBlip = true
        }
    )
end

function AddDestinationBlip(coords)
    TriggerEvent("waypointer:add", 
        "taxi-destination", --waypointer name
        {
            coords = coords, 
            entity = nil, -- No need to set coords when using entities
            sprite = 309, scale = 0.5, 
            short = true, 
            color = 28, 
            label = "Destination"
        }, 
        {
            coords = coords, -- No need to set coords when using entities
            color = 28, 
            onFoot = true, 
            radarThick = 16, 
            mapThick = 16, 
            range = 30, 
            removeBlip = true
        }
    )

    TriggerEvent("waypointer:setroute", "taxi-destination")
end

function WaitForConfirmation(ped)
    while not IsPedInVehicle(ped, currentTaxiVeh, false) and currentWaitingTime <= waitTime do 
        Citizen.Wait(1)
        currentWaitingTime = currentWaitingTime + 1
        if #(GetEntityCoords(ped) - GetEntityCoords(currentTaxiVeh)) < 5 then 
            DisableControlAction(0, 75, true)
            if IsDisabledControlJustReleased(0, 75) then 
                TaskEnterVehicle(ped, currentTaxiVeh, -1, 1, 1.0, 1, 0)
            end
        end
    end

    TriggerEvent("waypointer:remove", "taxi-"..GetVehicleNumberPlateText(currentTaxiVeh))

    if currentWaitingTime >= waitTime then 
        DeleteTaxi()
        TriggerEvent("notification:send", {color = "red", time = 10000, text = "You took too long to catch the taxi. He went away."})
        return
    end

    CloseMenu()
    TriggerEvent("side-menu:addOptions", {
        {id = "TAXI_NORMAL_WAY", label = "Normal Way", quantity = nil, cb = function() CloseMenu() DriveToDestination() end},
        {id = "TAXI_TELEPORT_WAY", label = "Teleport", quantity = nil, cb = function() CloseMenu() TeleportToDestination() end},
    })
end

function CloseMenu()
    TriggerEvent("side-menu:resetOptions")
end

function DriveToDestination()
    local ped = GetPlayerPed(-1)

    local taxiDestinationCoords = GetClosestStreetCoords(destination.x, destination.y, destination.z)
    TaskVehicleDriveToCoord(currentTaxiNpc, currentTaxiVeh, taxiDestinationCoords.x, taxiDestinationCoords.y, taxiDestinationCoords.z, 26.0, 0, "taxi", 411, 1.0)
    SetPedKeepTask(currentTaxiNpc, true)

    AddDestinationBlip(taxiDestinationCoords)

    while #(vector3(taxiDestinationCoords.x, taxiDestinationCoords.y, taxiDestinationCoords.z) - GetEntityCoords(ped)) >= 3.0 do
        Citizen.Wait(100)
        if IsControlJustReleased(0, 75) then 
            TriggerEvent("notification:send", {color = "red", time = 10000, text = "You left the taxi early. The taxi will leave you behind."})
            break
        end
    end

    TriggerEvent("waypointer:remove", "taxi-destination")
        
    TaskLeaveVehicle(ped, currentTaxiVeh, 0)

    Citizen.Wait(3000)

    local taxiCoords = GetEntityCoords(currentTaxiVeh)
    local taxiLeavingCoords = GetClosestStreetCoords(taxiCoords.x - math.random(-200, 200), taxiCoords.y - math.random(-200, 200), taxiCoords.z)
    TaskVehicleDriveToCoord(currentTaxiNpc, currentTaxiVeh, taxiLeavingCoords.x, taxiLeavingCoords.y, taxiLeavingCoords.z, 26.0, 0, "taxi", 411, 1.0)
    SetPedKeepTask(currentTaxiNpc, true)

    while #(vector3(taxiLeavingCoords.x, taxiLeavingCoords.y, taxiLeavingCoords.z) - GetEntityCoords(currentTaxiNpc)) >= 10 do
        Citizen.Wait(100)
    end

    DeleteTaxi()
end

function TeleportToDestination()
    DoScreenFadeOut(500)

    Citizen.Wait(1000)

    local ped = GetPlayerPed(-1)
    local taxiTeleportCoords = GetClosestStreetCoords(destination.x - math.random(-50, 50), destination.y - math.random(-50, 50), destination.z)
    SetEntityCoords(currentTaxiVeh, taxiTeleportCoords.x, taxiTeleportCoords.y, taxiTeleportCoords.z, 0.0, 0.0, 0.0, true)
    SetEntityHeading(currentTaxiVeh, taxiTeleportCoords.w)
    
    Citizen.Wait(1500)

    DoScreenFadeIn(500)

    DriveToDestination()
end

function GetClosestStreetCoords(x, y, z)
    local f, coords, heading = GetClosestVehicleNodeWithHeading(x, y, z, 12, 3.0, 0)
    
    return vector4(coords.x, coords.y, coords.z, heading)
end

function DeleteTaxi()
    DeleteEntity(currentTaxiNpc)
    DeleteVehicle(currentTaxiVeh)

    currentTaxiNpc = nil
    currentTaxiVeh = nil
    currentWaitingTime = 0
end