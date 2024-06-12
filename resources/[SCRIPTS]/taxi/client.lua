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

    if destination == nil then TriggerEvent("notification:send", {color = "red", time = 7000, text = "You need to set a waypoint first."}) return end
    destination = GetBlipCoords(GetFirstBlipInfoId(8))

    if not HasMoney(ped) then return end

    SpawnTaxi(ped)

    WaitForConfirmation(ped)
end

AddEventHandler("taxi:callTaxi", CallTaxi)

function HasMoney(ped)
    local distance = GetPedWaypointDistance(ped)
    local price = pricePerMeter * distance

    TriggerEvent("bank:changeBank", -price, function(check, needAmount)
        if check then 
            TriggerEvent("notification:send", {color = "green", time = 7000, text = "A taxi is on the way to you."})
            return true
        else
            TriggerEvent("notification:send", {color = "red", time = 7000, text = "You don't have enought money to call a taxi. You need at least $"..needAmount})
            return false
        end
    end)
end

function SpawnTaxi(ped)
    local pCoords = GetEntityCoords(ped)
    local f, rp, outHeading = GetClosestVehicleNodeWithHeading(pCoords.x - math.random(-1, 200), pCoords.y - math.random(-1, 200), pCoords.z, 12, 3.0, 0)
    local vehModel = "taxi"
    local npcModel = "a_m_y_stlat_01"

    RequestModel(vehModel)
    while not HasModelLoaded(vehModel) do
        Citizen.Wait(100)
    end

    currentTaxiVeh = CreateVehicle(vehModel, rp, outHeading, true, false)

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
    TaskVehicleDriveToCoord(currentTaxiNpc, currentTaxiVeh, pCoords.x, pCoords.y, pCoords.z, 26.0, 0, vehModel, 411, 10.0)
    SetPedKeepTask(currentTaxiNpc, true)
end

function WaitForConfirmation(ped)
    while not IsPedInVehicle(ped, currentTaxiVeh, false) and currentWaitingTime <= waitTime do 
        Citizen.Wait(100)
        currentWaitingTime = currentWaitingTime + 100
    end

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
    TaskVehicleDriveToCoord(currentTaxiNpc, currentTaxiVeh, destination.x, destination.y, destination.z, 26.0, 0, "taxi", 411, 10.0)
    SetPedKeepTask(currentTaxiNpc, true)

    while #(destination - GetEntityCoords(ped)) >= 50 do
        Citizen.Wait(100)
    end

    TaskLeaveVehicle(ped, currentTaxiVeh, 0)

    Citizen.Wait(3000)

    local taxiCoords = GetEntityCoords()
    local f, rp, outHeading = GetClosestVehicleNodeWithHeading(taxiCoords.x - math.random(-1, 200), taxiCoords.y - math.random(-1, 200), taxiCoords.z, 12, 3.0, 0)
    TaskVehicleDriveToCoord(currentTaxiNpc, currentTaxiVeh, rp.x, rp.y, rp.z, 26.0, 0, "taxi", 411, 10.0)
    SetPedKeepTask(currentTaxiNpc, true)

    while #(rp - GetEntityCoords(currentTaxiNpc)) >= 50 do
        Citizen.Wait(100)
    end

    DeleteTaxi()
end

function TeleportToDestination()
    local ped = GetPlayerPed(-1)
    local f, rp, outHeading = GetClosestVehicleNodeWithHeading(destination.x - math.random(-1, 200), destination.y - math.random(-1, 200), destination.z, 12, 3.0, 0)
    SetEntityCoords(currentTaxiVeh, rp.x, rp.y, rp.z, 0.0, 0.0, 0.0, true)
    SetEntityHeading(currentTaxiVeh, outHeading)
    
    DriveToDestination()
end

function DeleteTaxi()
    DeleteEntity(currentTaxiNpc)
    DeleteVehicle(currentTaxiVeh)

    currentTaxiNpc = nil
    currentTaxiVeh = nil
    currentWaitingTime = 0
end