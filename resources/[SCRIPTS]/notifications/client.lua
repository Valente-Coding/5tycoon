function SendNotification(data)
    SendNUIMessage(json.encode({type = "notification", data = data}))
end

RegisterNetEvent("notification:send")
AddEventHandler("notification:send", SendNotification)
