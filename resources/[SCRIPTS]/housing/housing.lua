local houseSaleBlips = {
    {coords = vector3(997.0684, -729.3065, 57.8157), price = 60000},
    {coords = vector3(997.0684, -729.3065, 57.8157), price = 80000},
    {coords = vector3(943.5446, -653.5113, 58.4287), price = 70000},
    {coords = vector3(), price = },
    {coords = vector3(), price = },
    {coords = vector3(), price = },
    {coords = vector3(), price = },
    {coords = vector3(), price = },
    {coords = vector3(), price = },
    {coords = vector3(), price = },
    {coords = vector3(), price = },
    {coords = vector3(), price = },
    {coords = vector3(), price = },
    {coords = vector3(), price = },
    {coords = vector3(), price = },
    {coords = vector3(), price = },
}

Citizen.CreateThread(function()
    local blips = {}

    for _, location in pairs(houseSaleBlips) do
        local blip = AddBlipForCoord(location.coords.x, location.coords.y, location.coords.z + 1)
        SetBlipSprite( blip, 350)
        SetBlipScale(blip, 1.0)
        SetBlipColour(blip, 4)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("House For Sale")
        EndTextCommandSetBlipName(blip)
        table.insert(blips, blip)
end
)