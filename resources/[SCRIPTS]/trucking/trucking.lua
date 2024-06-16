local MenuDisplay = false
local OnMission = false
local SpawnedMissionVeh = nil
local WaypointsCreated = {}
local NumberOfBoxes = 3
local rearOfVehicle = nil
local boxModel = nil
local box = nil
local DeliveryCompleted = false

local npcBlip = {{
    x = -320.5476,
    y = -1389.3766,
    z = 36.5002,
    h = 129.3882
}}

local MissionVehSpawn = {
    x = -336.4474,
    y = -1398.0050,
    z = 30.4201,
    h = 180.6195
}

local NearDeliveryPoints = {{
    coords = {
        x = 125.1992,
        y = -1681.8038,
        z = 29.4518
    },
    dropPoint = {
        x = 124.3447,
        y = -1675.8998,
        z = 29.4123
    }
}, {
    coords = {
        x = 203.8805,
        y = -1752.3889,
        z = 28.9502
    },
    dropPoint = {
        x = 207.8828,
        y = -1760.1200,
        z = 29.2684
    }
}, {
    coords = {
        x = 333.6156,
        y = -1003.8737,
        z = 29.3410
    },
    dropPoint = {
        x = 333.2864,
        y = -995.0946,
        z = 29.3098
    }
}, {
    coords = {
        x = -524.7351,
        y = -873.9084,
        z = 28.1729
    },
    dropPoint = {
        x = -534.2145,
        y = -872.5502,
        z = 27.1948
    }
}, {
    coords = {
        x = -668.1384,
        y = -1212.0399,
        z = 10.5957
    },
    dropPoint = {
        x = -664.4123,
        y = -1218.1064,
        z = 11.8129
    }
}, {
    coords = {
        x = -527.0165,
        y = -1778.4534,
        z = 21.3555
    },
    dropPoint = {
        x = -528.4014,
        y = -1784.2699,
        z = 21.5678
    }
}, {
    coords = {
        x = 104.6263,
        y = -1817.7787,
        z = 26.5312
    },
    dropPoint = {
        x = 95.3955,
        y = -1810.3585,
        z = 27.0797
    }
}, {
    coords = {
        x = 332.7674,
        y = -1276.0029,
        z = 31.7686
    },
    dropPoint = {
        x = 340.3990,
        y = -1270.7715,
        z = 32.0128
    }
}, {
    coords = {
        x = -10.9446,
        y = -729.7403,
        z = 32.2957
    },
    dropPoint = {
        x = -7.2147,
        y = -719.0940,
        z = 32.2503
    }
}}

local MediumDeliveryPoints = {{
    coords = {
        x = -7.2147,
        y = -719.0940,
        z = 32.2503
    }
}, {
    coords = {
        x = 1201.0251,
        y = -1385.7041,
        z = 35.2270
    }
}, {
    coords = {
        x = 1042.7601,
        y = -2177.4915,
        z = 31.4436
    }
}, {
    coords = {
        x = 164.5376,
        y = -3075.0129,
        z = 5.9130
    }
}, {
    coords = {
        x = 119.7690,
        y = -2581.8323,
        z = 6.0047
    }
}, {
    coords = {
        x = -765.9445,
        y = -2608.9468,
        z = 13.8285
    }
}, {
    coords = {
        x = -1060.6147,
        y = -2014.8705,
        z = 13.1616
    }
}, {
    coords = {
        x = -1622.1718,
        y = -810.4937,
        z = 10.0894
    }
}, {
    coords = {
        x = 827.6365,
        y = -125.0640,
        z = 80.2620
    }
}}

local FarDeliveryPoints = {{
    coords = {
        x = 646.2348,
        y = 597.0365,
        z = 128.9107
    }
}, {
    coords = {
        x = 2737.0703,
        y = 1454.1600,
        z = 29.0571
    }
}, {
    coords = {
        x = 1249.5817,
        y = -3297.1455,
        z = 5.8617
    }
}, {
    coords = {
        x = -2977.3325,
        y = 431.5482,
        z = 15.0386
    }
}, {
    coords = {
        x = 811.5959,
        y = 2198.4182,
        z = 52.1375
    }
}, {
    coords = {
        x = 1562.3636,
        y = 3782.5852,
        z = 34.4291
    }
}, {
    coords = {
        x = 1953.8124,
        y = 3767.5435,
        z = 32.2053
    }
}, {
    coords = {
        x = 2907.5132,
        y = 4424.3115,
        z = 48.3451
    }
}, {
    coords = {
        x = 44.5371,
        y = 6295.3125,
        z = 31.2412
    }
}}

function SelectVehicle(coords)
    local truckData = json.decode(GetExternalKvpString("save-load", "TRUCK_DATA"))
    local modelHash = nil
    local trailerHash = nil
    local spawnedVeh = nil

    if truckData.level == 0 or truckData.level == 1 then
        modelHash = GetHashKey("sadler")
    elseif truckData.level == 2 or truckData.level == 3 then
        modelHash = GetHashKey("burrito3")
    elseif truckData.level == 4 or truckData.level == 5 then
        modelHash = GetHashKey("mule")
    elseif truckData.level == 6 or truckData.level == 7 then
        modelHash = GetHashKey("benson")
    elseif truckData.level == 8 then
        modelHash = GetHashKey("pounder")
    elseif truckData.level == 9 or truckData.level == 10 then
        modelHash = GetHashKey("phantom")
        trailerHash = GetHashKey("trailers")
        spawnedVeh = SpawnVehicle(modelHash, coords)

        if trailerHash then
            local trailer = SpawnVehicle(trailerHash, coords)
            if trailer then
                AttachVehicleToTrailer(spawnedVeh, trailer, 10.0)
            end
        end

        return spawnedVeh
    end

    local SpawnedMissionVehInside = SpawnVehicle(modelHash, coords)
    return SpawnedMissionVehInside
end

function SpawnVehicle(modelHash, coords)
    local isModelValid = IsModelValid(modelHash)

    if isModelValid then
        RequestModel(modelHash)
        while not HasModelLoaded(modelHash) do
            Citizen.Wait(1)
        end

        local vehicle = CreateVehicle(modelHash, coords.x, coords.y, coords.z, coords.h, true, false)

        local playerPed = PlayerPedId()
        TaskWarpPedIntoVehicle(playerPed, vehicle, -1)

        return vehicle
    else
        print("Invalid model.")
        return nil
    end
end

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

function GetDeliveryPoint()
    local truckData = json.decode(GetExternalKvpString("save-load", "TRUCK_DATA"))

    if truckData.level < 5 then
        return NearDeliveryPoints[math.random(1, #NearDeliveryPoints)]
    elseif truckData.level >= 5 and truckData.level < 8 then
        return MediumDeliveryPoints[math.random(1, #MediumDeliveryPoints)]
    elseif truckData.level >= 8 then
        return FarDeliveryPoints[math.random(1, #FarDeliveryPoints)]
    end
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

function MakePlayerVehicleParked(playerPed)
    TaskLeaveVehicle(playerPed, SpawnedMissionVeh, 0)
    FreezeEntityPosition(SpawnedMissionVeh, true)
end

function MakePlayerVehicleNotParked()
    FreezeEntityPosition(SpawnedMissionVeh, false)
end

function UnloadingTruck(playerPed)
    TriggerEvent("notification:send", {
        text = "You are waiting for the team to finish unloading the cargo.",
        color = "blue",
        time = 4000
    })
    FreezeEntityPosition(playerPed, true)
    FreezeEntityPosition(SpawnedMissionVeh, true)
    DoScreenFadeIOut(500)
    Citizen.Wait(3000)
    DoScreenFadeIn(500)
    FreezeEntityPosition(playerPed, false)
    FreezeEntityPosition(SpawnedMissionVeh, false)
    TriggerEvent("notification:send", {
        text = "The cargo has been unloaded. You can now go back to the depot.",
        color = "green",
        time = 7000
    })
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

    TaskPlayAnim(playerPed, 'anim@heists@box_carry@', 'idle', 8.0, -8.0, -1, 50, 0, false, false, false)

    box = CreateObject(boxModel, playerCoords.x, playerCoords.y, playerCoords.z, true, true, true)
    AttachEntityToEntity(box, playerPed, GetPedBoneIndex(playerPed, 60309), 0.025, 0.08, 0.255, -145.0, 290.0, 0.0,
        true, true, false, true, 1, true)
end

function DropBox(boxDropoff)
    local playerPed = GetPlayerPed(-1)

    DetachEntity(box, false, false)
    DeleteEntity(box)
    ClearPedTasks(playerPed)
    SetModelAsNoLongerNeeded(box)
end

function DeliverBoxesByHand(playerPed, deliveryPoint)
    local vehHeading = GetEntityHeading(SpawnedMissionVeh)
    local vehCoords = GetEntityCoords(SpawnedMissionVeh)
    local rearOfVehicle = GetRearOfVehicle(vehHeading, vehCoords, 4.0)
    local dropPoint = deliveryPoint.dropPoint

    for i = 1, NumberOfBoxes, 1 do
        local distanceToRear =
            #(GetEntityCoords(playerPed) - vector3(rearOfVehicle.x, rearOfVehicle.y, rearOfVehicle.z))
        while distanceToRear > 1.5 do
            Citizen.Wait(1)
            CreateMarkers(0, rearOfVehicle.x, rearOfVehicle.y, rearOfVehicle.z, "blue")
            distanceToRear = #(GetEntityCoords(playerPed) - vector3(rearOfVehicle.x, rearOfVehicle.y, rearOfVehicle.z))
        end

        PickupBox(rearOfVehicle)

        Citizen.Wait(3000)

        local distanceToDrop = #(GetEntityCoords(playerPed) - vector3(dropPoint.x, dropPoint.y, dropPoint.z))
        while distanceToDrop > 1.5 do
            Citizen.Wait(1)
            CreateMarkers(0, dropPoint.x, dropPoint.y, dropPoint.z, "green")
            distanceToDrop = #(GetEntityCoords(playerPed) - vector3(dropPoint.x, dropPoint.y, dropPoint.z))
        end

        DropBox(dropPoint)
    end

    TriggerEvent("notification:send", {
        text = "All boxes have been delivered. You can now go back to the depot.",
        color = "green",
        time = 7000
    })

    MakePlayerVehicleNotParked()

    DeliveryCompleted = true
end

function GettingPaid()
    local truckData = json.decode(GetExternalKvpString("save-load", "TRUCK_DATA"))
    local payment = math.random(1000, 2000)
    payment = math.floor(payment + (payment * (truckData.level / 5)))
    TriggerEvent("notification:send", {
        time = 5000,
        color = "green",
        text = "You have been paid $" .. payment
    })
    TriggerEvent("bank:changeBank", payment)
    truckData.jobs = truckData.jobs + 1
    if truckData.level < 10 and truckData.jobs <= 100 then
        truckData.level = math.floor(truckData.jobs / 10)
        if truckData.level == 100 then
            TriggerEvent('notification:center', {
                time = 5000,
                text = "You reached max level."
            })
            truckData.canBuy = true
        end
    end
    TriggerEvent("save-load:setGlobalVariables", {{
        name = "TRUCK_DATA",
        type = "string",
        value = json.encode(truckData)
    }})
end

function Mission()
    OnMission = true

    local truckData = json.decode(GetExternalKvpString("save-load", "TRUCK_DATA"))
    local playerPed = GetPlayerPed(-1)
    SpawnedMissionVeh = SelectVehicle(MissionVehSpawn)
    local deliveryPoint = GetDeliveryPoint()

    WaypointerCreate("delivery", deliveryPoint.coords, nil, 1, true, 5, "Delivery Point", false, false, true)

    local function WaitUntilClose(coords, threshold)
        local distance = #(GetEntityCoords(playerPed) - vector3(coords.x, coords.y, coords.z))
        while distance > threshold do
            Citizen.Wait(100)
            distance = #(GetEntityCoords(playerPed) - vector3(coords.x, coords.y, coords.z))
        end
    end

    if truckData.level < 5 then
        WaitUntilClose(deliveryPoint.coords, 5.0)

        if IsPedInVehicle(playerPed, SpawnedMissionVeh, false) then
            TriggerEvent("side-menu:addOptions", {{
                id = "trucking_job_deliver_near",
                label = "Deliver Boxes",
                cb = function()
                    CloseAllMenus()
                    MakePlayerVehicleParked(playerPed)
                    DeliverBoxesByHand(playerPed, deliveryPoint)
                end
            }})
        else
            TriggerEvent("notification:send", {
                text = "You must be in the job vehicle to do the delivery.",
                color = "red",
                time = 4000
            })
        end
    else
        WaitUntilClose(deliveryPoint.coords, 5.0)

        if IsPedInVehicle(playerPed, SpawnedMissionVeh, false) then
            TriggerEvent("side-menu:addOptions", {{
                id = "trucking_job_deliver_far",
                label = "Start Unloading",
                cb = function()
                    CloseAllMenus()
                    UnloadingTruck(playerPed)
                end
            }})
        else
            TriggerEvent("notification:send", {
                text = "You must be in the job vehicle to start unloading.",
                color = "red",
                time = 4000
            })
        end
    end

    while not DeliveryCompleted do
        Citizen.Wait(100)
    end

    RemoveAllWaypoints()

    WaypointerCreate("depot", MissionVehSpawn, nil, 1, true, 5, "Depot", false, true, true)

    WaitUntilClose(MissionVehSpawn, 5.0)

    if IsPedInVehicle(playerPed, SpawnedMissionVeh, false) then
        RemoveAllWaypoints()
        DeleteMissionVeh()
        OnMission = false
        GettingPaid() -- Ensure this function is called when the player reaches the depot
        IsGoingBackToDepot = false
        IsGoingToDelivery = false
    else
        TriggerEvent("notification:send", {
            text = "You must be in the job vehicle to return to the depot.",
            color = "red",
            time = 4000
        })
    end
end

Citizen.CreateThread(function()

    for _, location in ipairs(npcBlip) do
        local blip = AddBlipForCoord(location.x, location.y, location.z)
        SetBlipSprite(blip, 477)
        SetBlipScale(blip, 0.7)
        SetBlipColour(blip, 5)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Trucking Job")
        EndTextCommandSetBlipName(blip)
        local pedModel = "a_m_m_indian_01"
        RequestModel(pedModel)
        while not HasModelLoaded(pedModel) do
            Citizen.Wait(1)
        end

        local pedSpawn = CreateBrainlessNpc(pedModel, location.x, location.y, location.z - 1, location.h, false)
        location.ped = pedSpawn
    end

end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        local playerPed = GetPlayerPed(-1)
        local playerCoords = GetEntityCoords(playerPed)
        local distance = #(playerCoords - vector3(npcBlip[1].x, npcBlip[1].y, npcBlip[1].z))

        local truckingData = json.decode(GetExternalKvpString("save-load", "TRUCK_DATA"))

        if distance < 2.0 and not MenuDisplay then
            if not OnMission then
                MenuDisplay = true
                TriggerEvent("side-menu:addOptions", {{
                    id = "trucking_job_jobs",
                    label = "Number of Jobs:",
                    quantity = tostring(truckingData.jobs)
                }, {
                    id = "trucking_job_level",
                    label = "Job Level:",
                    quantity = tostring(truckingData.level)
                }, {
                    id = "trucking_job_start",
                    label = "Start Job",
                    cb = function()
                        CloseAllMenus(100)
                        Mission()
                    end
                }})
            else
                MenuDisplay = true
                TriggerEvent("side-menu:addOptions", {{
                    id = "trucking_job_cancel_mission",
                    label = "Cancel Job",
                    cb = function()
                        CloseAllMenus()
                        RemoveAllWaypoints()
                        DeleteMissionVeh(SpawnedMissionVeh)
                        OnMission = false
                        IsGoingBackToDepot = nil
                        IsGoingToDelivery = nil
                    end
                }})
            end
        elseif distance > 2.0 and distance <= 3.0 and MenuDisplay then
            CloseAllMenus()
        end
    end
end)