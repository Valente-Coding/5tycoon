Citizen.CreateThread(function()
    local vehicles = json.decode(GetExternalKvpString("save-load", "CHAR_VEHICLES"))
    local isChecking = false

    while true do
        Citizen.Wait(500)

        local playerPed = GetPlayerPed(-1)
        local vehEntering = GetVehiclePedIsTryingToEnter(playerPed)

        if DoesEntityExist(vehEntering) and not isChecking then
            local chance = math.random(0, 100)
            local vehiclePlate = GetVehicleNumberPlateText(vehEntering)
            local isOwned = IsVehicleOwnedByPlayer(vehiclePlate, vehicles)

            local isItLocked = GetVehicleDoorLockStatus(vehEntering)

            if not isOwned then
                if isItLocked ~= 1 then
                    if chance <= 40 then
                        if GetPlayerWantedLevel(playerPed) == 0 then
                            SetPlayerWantedLevel(PlayerId(), 1, false)
                            SetPlayerWantedLevelNow(PlayerId(), false)
                            TriggerEvent("notification:send", {color = "red", time = 5000, text = "Stolen vehicle: Police alerted."})
                            Wait(1000)
                        end
                    else
                        TriggerEvent("notification:send", {color = "red", time = 5000, text = "Stolen vehicle: You got lucky."})
                        Wait(1000)
                        SetPlayerWantedLevel(PlayerId(), 0, false)
                        SetPlayerWantedLevelNow(PlayerId(), false)
                        Wait(1000)
                    end
                end
            end

            isChecking = true
            Citizen.Wait(500)
            isChecking = false
        end
    end
end)

function IsVehicleOwnedByPlayer(plate, vehicleData)
    for _, vehicleInfo in ipairs(vehicleData) do
        local infoPlate = vehicleInfo.plate
        if infoPlate and infoPlate == plate then
            return true
        end
    end
    return false
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)

        local parkedVehicles = GetGamePool("CVehicle")
        local playerPed = GetPlayerPed(-1)

        for _, vehicle in ipairs(parkedVehicles) do
            local vehiclePos = GetEntityCoords(vehicle)

            if IsEntityDead(vehicle) and not IsPedInAnyVehicle(playerPed, true) then
                SetVehicleDoorsLocked(vehicle, 2)
            end
        end
    end
end)