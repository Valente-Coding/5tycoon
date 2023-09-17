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

RegisterCommand("testnoti", function(source, args, rawCommand)
    if args[1] and args[2] and args[3] then 
        if args[1] == "center" then 
            SendCenterNotification({text = args[2], time = tonumber(args[3])})
        elseif args[1] == "side" then 
            SendNotification({text = args[2], time = tonumber(args[3])})
        end
    end
end, false)