local _currentOptions = {}

RegisterNetEvent("side-menu:addOptions")
RegisterNetEvent("side-menu:removeOptions")
RegisterNetEvent("side-menu:openInputBox")


function AddOptions(options) 
    for _, option in pairs(options) do 
        if option.addCB then 
            option.addCB()
        end

        table.insert(_currentOptions, option)
    end

    UpdateOptionList() 
end

function RemoveOptions(options)
    for _, option in pairs(options) do 
        for i, currentOption in pairs(_currentOptions) do 
            if option.id == currentOption.id then 
                if currentOption.removeCB then 
                    currentOption.removeCB()
                end
                
                table.remove(_currentOptions, i)
            end
        end
    end

    UpdateOptionList() 
end

function UpdateOptions(options) 
    for _, option in pairs(options) do 
        for i, currentOption in pairs(_currentOptions) do 
            if option.id == currentOption.id then 
                _currentOptions[i] = option
            end
        end
    end

    UpdateOptionList() 
end

function UpdateOptionList() 
    local options = {}
    for _, option in pairs(_currentOptions) do 
        table.insert(options, {id = option.id, label = option.label, quantity = option.quantity})
    end
    SendNUIMessage(json.encode({type = "display-options", options = options}))
end

function RunOptionCB(id)
    for _, option in pairs(_currentOptions) do 
        if option.id == id then 
            if option.cb then
                option.cb()
            end
        end
    end
end

local inside = false
Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1)
        if #_currentOptions > 0 then 
            if IsControlJustReleased(0, 172) then 
                SendNUIMessage(json.encode({type = "selectup"}))
            end

            if IsControlJustReleased(0, 173) then 
                SendNUIMessage(json.encode({type = "selectdown"}))
            end

            if IsControlJustReleased(0, 191) then 
                SendNUIMessage(json.encode({type = "select"}))
            end
        end
    end
end)

RegisterNUICallback('selectoption', function(data, cb)
    RunOptionCB(data.id)

    cb('ok')
end)

local _inputCB = nil
function OpenInputBox(data)
    if data.cb then 
        _inputCB = data.cb
    end

    SetNuiFocus(true, true)
    SendNUIMessage(json.encode({type = "openinput", inputData = data}))
end

RegisterNUICallback('inputresult', function(data, cb)
    SetNuiFocus(false, false)
    if _inputCB then
        _inputCB(data.result)
    end

    cb('ok')
end)

AddEventHandler("side-menu:addOptions", AddOptions)
AddEventHandler("side-menu:removeOptions", RemoveOptions)
AddEventHandler("side-menu:updateOptions", UpdateOptions)
AddEventHandler("side-menu:openInputBox", OpenInputBox)

--[[ RegisterCommand("additems", function(source, args, rawCommand) 
    AddOptions({
        {id = "a", label = "a", quantity = 1},
        {id = "b", label = "b", quantity = 1},
        {id = "c", label = "c", quantity = 1},
        {id = "d", label = "d", quantity = 1},
        {id = "e", label = "e", quantity = 1},
        {id = "f", label = "f", quantity = 1},
        {id = "g", label = "g", quantity = 1},
        {id = "h", label = "h", quantity = 1},
        {id = "i", label = "i", quantity = 1},
        {id = "j", label = "j", quantity = 1},
        {id = "k", label = "k", quantity = 1},
        {id = "l", label = "l", quantity = 1},
        {id = "m", label = "m", quantity = 1},
        {id = "n", label = "n", quantity = 1},
        {id = "o", label = "o", quantity = 1},
        {id = "p", label = "p", quantity = 1},
    })
end, false) ]]