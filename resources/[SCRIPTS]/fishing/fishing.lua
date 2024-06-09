local menuDisplay = false
local isFishing = false

local fishingLocations = {
    {coords = vector4(-463.6013, -2434.8252, 6.0008, 51.0012)},
    {coords = vector4(-791.7903, -1462.9906, 5.0005, 82.9109)},
    {coords = vector4(-1854.4937, -1245.3595, 8.6158, 139.0660)},
    {coords = vector4(-3427.1448, 968.4360, 8.3467, 88.8060)},
    {coords = vector4(3866.4280, 4463.6470, 2.7276, 271.7113)}
}



Citizen.CreateThread(function()

    local blips = {}

    for _, location in ipairs(fishingLocations) do

        local blip = AddBlipForCoord(location.coords.x, location.coords.y, location.coords.z)
        SetBlipSprite(blip, 68)
        SetBlipScale(blip, 0.7)
        SetBlipColour(blip, 7)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Fishing Spot")
        EndTextCommandSetBlipName(blip)
        table.insert(blips, blip)

    end
    
end)


function playerFishing(x, y, z)
    local playerPed = GetPlayerPed(-1)
    SetEntityCoords(playerPed, x, y, z - 1.0, 0.0, 0.0, 0.0, false)
    Wait(5)
end

function FishCaught(minPrice, maxPrice, fishType)
    local fishPrices = math.random(minPrice, maxPrice)
    local fishingData = json.decode(GetExternalKvpString("save-load", "FISHING_DATA"))
    fishPrice = math.floor(fishPrices + (fishPrices * (fishingData.level / 10)))
    fishingData.fishes = fishingData.fishes + 1
    if fishingData.level < 10 then
        fishingData.level = math.floor(fishingData.fishes / 100)
    end
    TriggerEvent("save-load:setGlobalVariables", {{name = "FISHING_DATA", type = "string", value = json.encode(fishingData)}})
    TriggerEvent("bank:changeCash", fishPrice)
    TriggerEvent("notification:send", {color = "green", time = 3000, text = fishType .. " caught and sold for $" .. fishPrice})
end

function SearchFishing()
    local caughtFish = math.random(1, 1000)
    if caughtFish <= 600 then
        FishCaught(20, 50, "Common fish")
    elseif caughtFish <= 900 then
        FishCaught(50, 100, "Uncommon fish")
    elseif caughtFish <= 990 then
        FishCaught(100, 200, "Rare fish")
    elseif caughtFish <= 999 then
        FishCaught(200, 500, "Ultra rare fish")
    elseif caughtFish <= 1000 then
        FishCaught(5000, 10000, "WHALE")
    end
end


function CloseAllMenus(cooldown, stay)
    Citizen.CreateThread(function()   
        if cooldown then
            Citizen.Wait(cooldown)
        end

        if stay then

        else
            menuDisplay = false
        end
    end)

    TriggerEvent("side-menu:resetOptions")
end


function StartFishing()
    local playerPed = GetPlayerPed(-1)
    FreezeEntityPosition(playerPed, true)
    TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_STAND_FISHING", 0, true)
    
    Citizen.CreateThread(function()
        while isFishing do
            time = math.random(30000, 60000)
            Wait(time)
            if isFishing then
                SearchFishing()
            end
        end
    end)

    TriggerEvent("side-menu:addOptions", {
        {id = "fishing_stop", label = "Stop fishing", cb = function()
            isFishing = false
            CloseAllMenus()
            FreezeEntityPosition(playerPed, false)
            ClearPedTasks(playerPed)
        end}
    })
end


Citizen.CreateThread(function()
    while true do
        Wait(10)
        local playerPed = GetPlayerPed(-1)
        local playerCoords = GetEntityCoords(playerPed)
        local playerHeading = GetEntityHeading(playerPed)

        -- if the player is within 2 units of the fishingLocations, display the text to start fishing.

        dist = nil

        for _, location in ipairs(fishingLocations) do
            dist = #(playerCoords - vector3(location.coords.x, location.coords.y, location.coords.z))
            if dist <= 2.0 and menuDisplay == false then
                menuDisplay = true
                TriggerEvent("side-menu:addOptions", {
                    {id = "fishing_start", label = "Start fishing", cb = function()
                        isFishing = true
                        CloseAllMenus(1, true)
                        StartFishing()
                    end}
                })
            elseif dist > 2.0 and dist <= 3.0 and menuDisplay == true then
                CloseAllMenus()
            end
        end
    end
end)