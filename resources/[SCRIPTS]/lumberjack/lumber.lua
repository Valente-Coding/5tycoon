local npc_blip = {
    {x = -560.9688, y = 5351.5479, z = 69.2223, h = 69.0079}
}

--create the tree cords without heading

local trees = {
    {x = -646.4113, y = 5258.2148, z = 75.2900},
    {x = -664.8446, y = 5267.7358, z = 76.0087},
    {x = -679.9406, y = 5263.9971, z = 76.6440},
    {x = -631.4731, y = 5244.8062, z = 74.3078},
    {x = -618.1598, y = 5247.0020, z = 72.7108},
    {x = -614.6541, y = 5233.7979, z = 73.5117}
}

-- create the car spawn coords

local car = {
    {x = -566.9289, y = 5353.4385, z = 69.7998, h = 159.2364}
}

-- create the lumberjack blip

Citizen.CreateThread(function()
    for k,v in ipairs(npc_blip) do
        local blip = AddBlipForCoord(v.x, v.y, v.z)
        SetBlipSprite(blip, 652)
        SetBlipColour(blip, 1)
        SetBlipScale(blip, 0.8)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Lumberjack Job")
        EndTextCommandSetBlipName(blip)

        -- spawn the NPC to start the job

        local hash = GetHashKey("s_m_m_lathandy_01")
        while not HasModelLoaded(hash) do
            RequestModel(hash)
            Wait(20)
        end
        
        -- spawn the npc at x = -560.9688, y = 5351.5479, z = 70.2223, h = 69.0079

        ped = CreatePed("PED_TYPE_CIVMALE", "s_m_m_lathandy_01", v.x, v.y, v.z, v.h, false, false)
        -- Set NPC invincible, unkillable and frozen
        SetEntityInvincible(ped, true)
        FreezeEntityPosition(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
    end
end)


-- create the lumberjack job

local isLumberjack = false
local isCarSpawned = false
local isTreeCut = false
local MenuDisplay = false

Citizen.CreateThread(function()

    while true do
        Citizen.Wait(10)
        local playerPed = GetPlayerPed(-1)
        local playerCoords = GetEntityCoords(playerPed)
        local distance = GetDistanceBetweenCoords(playerCoords, npc_blip.x, npc_blip.y, npc_blip.z, true)

        if distance < 2 then
        
            MenuDisplay = true
            TriggerEvent("")
        
        end

    end

end)