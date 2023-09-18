function SendNotification(data)
    SendNUIMessage(json.encode({type = "side", data = data}))
end

function SendCenterNotification(data)
    SendNUIMessage(json.encode({type = "center", data = data}))
end

RegisterNetEvent("notification:center")
AddEventHandler("notification:center", SendCenterNotification)

RegisterNetEvent("notification:side")
AddEventHandler("notification:side", SendNotification)
