local weaponsPresets = {
    {
        {model = "weapon_nightstick", ammo = 1},
    },
    {
        {model = "weapon_nightstick", ammo = 1},
        {model = "weapon_stungun", ammo = 10},
    },
    {
        {model = "weapon_nightstick", ammo = 1},
        {model = "weapon_stungun", ammo = 10},
        {model = "weapon_pistol", ammo = 200},
    },
    {
        {model = "weapon_nightstick", ammo = 1},
        {model = "weapon_stungun", ammo = 10},
        {model = "weapon_pistol", ammo = 200},
        {model = "weapon_pumpshotgun_mk2", ammo = 500},
    },
    {
        {model = "weapon_nightstick", ammo = 1},
        {model = "weapon_stungun", ammo = 10},
        {model = "weapon_pistol", ammo = 200},
        {model = "weapon_carbinerifle_mk2", ammo = 500},
    },
}

local cops = {}


Citizen.CreateThread(function()
    SetPoliceRadarBlips(false)
    while true do 
        Citizen.Wait(1000)
        local pId = PlayerId()
        local pPed = GetPlayerPed(-1)
        local pCoords = GetEntityCoords(pPed)
        local pWantedLvl = GetPlayerWantedLevel(pId)

        if pWantedLvl ~= 0 then 
            for ped in EnumeratePeds() do
                local pedType = GetPedType(ped)
                if pedType == 27 or pedType == 28 or pedType == 6 then 
                    if not IsCopInList(ped) then
                        table.insert(cops, ped)
                        RemoveAllPedWeapons(ped)
                        
                        for _, weapon in pairs(weaponsPresets[pWantedLvl]) do
                            GiveWeaponToPed(ped, GetHashKey(weapon.model), weapon.ammo, false, false)
                        end
                    end
                end
            end
        end
    end 
end)

function IsCopInList(ped)
    local found = false
    for _, cop in pairs(cops) do 
        if cop == ped then 
            found = true
            break
        end
    end

    return found
end

function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(
        function()
            local iter, id = initFunc()
            if not id or id == 0 then
                disposeFunc(iter)
                return
            end

            local enum = {handle = iter, destructor = disposeFunc}
            setmetatable(enum, entityEnumerator)

            local next = true
            repeat
                coroutine.yield(id)
                next, id = moveFunc(iter)
            until not next

            enum.destructor, enum.handle = nil, nil
            disposeFunc(iter)
        end
    )
end

function EnumeratePeds()
    return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end