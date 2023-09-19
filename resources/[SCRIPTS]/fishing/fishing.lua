local fishingLocations = {
    {coords = vector3(-463.6013, -2434.8252, 6.0008, 51.0012)},
    {coords = vector3(-791.7903, -1462.9906, 5.0005, 82.9109)},
    {coords = vector3(-1854.4937, -1245.3595, 8.6158, 139.0660)},
    {coords = vector3(-3427.1448, 968.4360, 8.3467, 88.8060)},
    {coords = vector3(3866.4280, 4463.6470, 2.7276, 271.7113)}
}


local menuDisplay = false


Citizen.CreateThread(function()

    local blips = {}

    for _, location in pairs(fishingLocations) do

        local blip = AddBlipForCoord(location.coords.x, location.coords.y, location.coords.z)
        SetBlipSprite(blip, 68)
        SetBlipScale(blip, 0.7)
        SetBlipColour(blip, 5)
        SetBlipAsShortRange(blip, false)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("fishing")
        EndTextCommandSetBlipName(blip)
        table.insert(blips, blip)

    end

    while true do

        Citizen.Wait(1)

        local playerPed(GetPlayerPed(-1))
        local playerCoords(GetEntityCoords(playerPed))
        local isPlayerInVehicle = IsPedInAnyVehicle(playerPed, false)

        for _, location in pairs(fishingLocations) do

            local distance = #(playerCoords - location.coords)

            if distance < 50.0 then

                DrawMarker(
                    25,
                    location.coords.x,
                    location.coords.y,
                    location.coords.z - 0.8,
                    0.0, 0.0, 0.0,
                    0, 0, 0,
                    2.0, 2.0, 1.0,
                    0, 191, 255, 100,
                    false, false, true, 2, false, nil, nil, false
                )

                if distance < 2.0 and not isPlayerInVehicle then

                    

                end

            end

        end

    end

end)