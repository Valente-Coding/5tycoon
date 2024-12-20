Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1)
        DisableControlAction(0, 37, true)
        if IsDisabledControlJustPressed(0, 37) then 
            if GetExternalKvpInt("save-load", "CAN_OPEN_POCKETS") == 0 then
                TriggerEvent("side-menu:addOptions", GetInventoryOptions())
            end
        end

        if IsDisabledControlJustReleased(0, 37) then 
            if GetExternalKvpInt("save-load", "CAN_OPEN_POCKETS") == 0 then
                TriggerEvent("side-menu:removeOptions", GetInventoryOptions())
            end
        end
    end
end)

function GetItemCB(id)
    local cb = nil

    for _, itemCB in pairs(Config.ItemCBs) do 
        if itemCB.id == id then 
            cb = itemCB.cb
        end
    end

    return cb
end

function GetInventoryItems() 
    local invItems = GetExternalKvpString("save-load", "INV_ITEMS")
    return json.decode(invItems)
end

function GetInventoryOptions() 
    local items = GetInventoryItems() 

    local options = {
        {id = "CASH_BALANCE", label = "Cash:", quantity = GetExternalKvpInt("save-load", "CASH_BALANCE"), cb = GetItemCB("CASH_BALANCE")},
        {id = "CALL_TAXI", label = "Call Taxi", quantity = "", cb = function() TriggerEvent("taxi:callTaxi") end},
    }
    
    if GetExternalKvpInt("save-load", "DIRTY_DISPLAY") == 1 then 
        table.insert(options, {id = "DIRTY_BALANCE", label = "Dirty:", quantity = GetExternalKvpInt("save-load", "DIRTY_BALANCE"), cb = GetItemCB("DIRTY_BALANCE")})
    end

    for _, item in pairs(items) do 
        table.insert(options, {id = item.id, label = item.label, quantity = item.quantity, cb = GetItemCB(item.id)})
    end

    return options
end

RegisterNetEvent("inventory:addItems")
RegisterNetEvent("inventory:removeItems")

function AddItemsToInventory(itemsData)
    local items = GetInventoryItems()

    local found = nil
    for i, itemData in pairs(itemsData) do 
        found = nil
        for j, item in pairs(items) do 
            if item.id == itemData.id then 
                found = j
                break
            end
        end

        if found then 
            items[found].quantity = items[found].quantity + itemData.quantity
        else
            table.insert(items, {id = itemData.id, label = itemData.label, quantity = itemData.quantity})
        end
    end

    TriggerEvent("save-load:setGlobalVariables", {{name = "INV_ITEMS", type = "string", value = json.encode(items)}})
    TriggerEvent("side-menu:updateOptions", GetInventoryOptions())
end

function RemoveItemsFromInventory(itemsData)
    local items = GetInventoryItems()

    for i, itemData in pairs(itemsData) do 
        for j, item in pairs(items) do 
            if item.id == itemData.id then 
                items[j].quantity = items[j].quantity - itemData.quantity

                if items[j].quantity <= 0 then 
                    table.remove(items, j)
                end
                break
            end
        end
    end

    TriggerEvent("save-load:setGlobalVariables", {{name = "INV_ITEMS", type = "string", value = json.encode(items)}})
    TriggerEvent("side-menu:updateOptions", GetInventoryOptions())
end

AddEventHandler("inventory:addItems", AddItemsToInventory)
AddEventHandler("inventory:removeItems", RemoveItemsFromInventory)

RegisterCommand("additem", function(source, args, rawCommand)
    if args[1] then 
        local qty = 1

        if args[2] then 
            qty = tonumber(args[2])
        end

        AddItemsToInventory({{id = args[1], label = args[1], quantity = qty}})
    end
end, false)
