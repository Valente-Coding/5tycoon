local waypointers = {}
local currentRoute = nil

function CreateBlip(x, y, z, sprite, scale, short, color, label) 
    local blip = AddBlipForCoord(x, y, z)

    SetBlipSprite(blip, sprite)
    SetBlipScale(blip, scale)
    SetBlipAsShortRange(blip, short)
    SetBlipColour(blip, color)
    
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(label)
    EndTextCommandSetBlipName(blip)

    return blip
end

function CreateRoute(coords, color, onFoot, radarThick, mapThick, name, range, removeBlip) 
    RemoveRoute()
    
    currentRoute = {name = name, range = range, coords = coords, removeBlip = removeBlip}
    ClearGpsCustomRoute()
    StartGpsMultiRoute(color, true, onFoot)
    AddPointToGpsMultiRoute(coords.x, coords.y, coords.z)
    SetGpsCustomRouteRender(true, radarThick, mapThick)
    SetGpsMultiRouteRender(true)
end

function RemoveRoute()
    currentRoute = nil
    SetGpsCustomRouteRender(false, 8, 8)
    SetGpsMultiRouteRender(false)
    ClearGpsCustomRoute()
end

RegisterNetEvent("waypointer:add")

function AddWaypointer(waypointerName, blipData, routeData) 
    if blipData == nil then 
        return 
    end

    local newBlip = CreateBlip(blipData.coords.x, blipData.coords.y, blipData.coords.z, blipData.sprite, tonumber(blipData.scale), blipData.short, blipData.color, blipData.label) 
    table.insert(waypointers, {name = waypointerName, blip = newBlip, blipData = blipData, routeData = routeData})
end

AddEventHandler("waypointer:add", AddWaypointer)




RegisterNetEvent("waypointer:remove")

function RemoveWaypointer(waypointerName) 
    for _, waypoint in pairs(waypointers) do 
        if waypoint.name == waypointerName then 
            RemoveBlip(waypoint.blip)
            if currentRoute == waypointerName then 
                RemoveRoute()
            end
        end
    end
end

AddEventHandler("waypointer:remove", RemoveWaypointer)



RegisterNetEvent("waypointer:setroute")

function SetRoute(waypointerName) 
    for _, waypoint in pairs(waypointers) do 
        if waypoint.name == waypointerName then 
            if waypoint.routeData then
                CreateRoute(waypoint.routeData.coords, waypoint.routeData.color, waypoint.routeData.onFoot, waypoint.routeData.radarThick, waypoint.routeData.mapThick, waypointerName, waypoint.routeData.range, waypoint.routeData.removeBlip) 
            else
                SetNewWaypoint(waypoint.blipData.coords.x, waypoint.blipData.coords.y)
            end
        end
    end
end

AddEventHandler("waypointer:setroute", SetRoute)

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(100)

        if currentRoute ~= nil then
            local ped = GetPlayerPed(-1)
            local coords = GetEntityCoords(ped)

            local dist = #(coords - vector3(currentRoute.coords.x, currentRoute.coords.y, currentRoute.coords.z))
            if dist <= currentRoute.range then
                if currentRoute.removeBlip == true then 
                    RemoveWaypointer(currentRoute.name) 
                end
                RemoveRoute()
            end
        end
    end
end)