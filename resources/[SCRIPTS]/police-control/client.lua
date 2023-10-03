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
        {model = "weapon_carbinerifle", ammo = 500},
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
    while true do 
        Citizen.Wait(1000)
        local pId = PlayerId()
        local pPed = GetPlayerPed(-1)
        local pCoords = GetEntityCoords(pPed)
        local pWantedLvl = GetPlayerWantedLevel(pId)

        if pWantedLvl ~= 0 then 
            for ped in EnumeratePeds() do
                if GetPedType(ped) == "PED_TYPE_COP" then 
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