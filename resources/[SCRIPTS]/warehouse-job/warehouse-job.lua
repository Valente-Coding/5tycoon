local warehouseLocations = {
    {
        coords = vector4(152.6127, -3092.4675, 5.8963, 89.3102),
        pickupBoxesLocations = {
            vector3(137.0742, -3100.2688, 5.8955),
            vector3(139.5392, -3102.3745, 5.8963),
            vector3(138.5618, -3111.3069, 5.8963),
            vector3(151.3942, -3099.5686, 5.8963),
            vector3(134.7071, -3111.3042, 5.8963),
            vector3(130.6303, -3110.5508, 5.8963),
            vector3(122.1661, -3111.8899, 5.9960),
            vector3(121.9690, -3108.6843, 5.9988)
        },
        putDownBoxesLocation = {
            vector3(129.4729, -3079.4399, 5.9038),
            vector3(126.4441, -3074.7095, 5.9414, 358.4389),
            vector3(143.5693, -3074.8318, 5.8963, 2.8095)
        }
    }
}




Citizen.CreateThread(function()
    local blips = {}

    for _, location in pairs(deliveryDepots) do
        local blip = AddBlipForCoord(location.coords.x, location.coords.y, location.coords.z)
        SetBlipSprite(blip, 568)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.8)
        SetBlipColour(blip, 54)
        SetBlipAsShortRange(blip, false)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Warehouse Job")
        EndTextCommandSetBlipName(blip)
        local pedModel = "a_m_m_farmer_01"
        RequestModel(pedModel)
        while not HasModelLoaded(pedModel) do
            Citizen.Wait(1)
        end
        local pedSpawn = CreatePed(26, GetHashKey(pedModel), location.coords.x, location.coords.y, location.coords.z - 1, location.coords.w, false, true)
        SetEntityInvincible(pedSpawn, true)
        location.ped = pedSpawn
    end
end)