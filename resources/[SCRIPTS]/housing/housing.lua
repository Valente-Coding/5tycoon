local houseSaleBlips = {
    {coords = vector3(997.0684, -729.3065, 57.8157), price = 60000},
    {coords = vector3(970.8563, -701.0776, 58.4820), price = 80000},
    {coords = vector3(943.5446, -653.5113, 58.4287), price = 70000},
    {coords = vector3(886.7933, -608.1030, 58.4451), price = 70000},
    {coords = vector3(844.1935, -562.9882, 57.8339), price = 75000},
    {coords = vector3(315.9535, 501.3657, 153.1798), price = 250000},
    {coords = vector3(119.3956, 494.2162, 147.3429), price = 180000},
    {coords = vector3(-230.4202, 488.3306, 128.7680), price = 200000},
    {coords = vector3(-312.1780, 474.7194, 111.8241), price = 350000},
    {coords = vector3(-355.5244, 469.8810, 112.4893), price = 500000},
    {coords = vector3(-297.9718, 380.2416, 112.0956), price = 260000},
    {coords = vector3(-371.8848, 343.7934, 109.9427), price = 300000},
    {coords = vector3(-520.5744, 594.1549, 120.8365), price = 250000},
    {coords = vector3(-339.9535, 625.8067, 171.3567), price = 700000},
    {coords = vector3(-700.7934, 647.3782, 155.1753), price = 1100000},
    {coords = vector3(-1496.0587, 437.2909, 112.4979), price = 450000},
    {coords = vector3(-1667.2349, -441.5058, 40.3557), price = 650000},
    {coords = vector3(-1490.5225, -658.6225, 29.0251), price = 10000},
    {coords = vector3(-1459.0474, -659.1971, 29.5830), price = 10000},
    {coords = vector3(279.8749, -1993.6436, 20.8038), price = 30000},
    {coords = vector3(291.3394, -1980.5107, 21.6005), price = 25000},
    {coords = vector3(324.0533, -1937.4679, 25.0190), price = 45000},
    {coords = vector3(398.4351, -1789.3022, 29.1593), price = 15000},
    {coords = vector3(332.8919, -1741.0638, 29.7306), price = 45000},
    {coords = vector3(-14.1733, -1441.8700, 31.1015), price = 50000},
    {coords = vector3(-216.5681, -1674.2344, 34.4632), price = 12000},
    {coords = vector3(-33.9881, -1847.2666, 26.1936), price = 30000},
    {coords = vector3(130.4368, -1853.6016, 25.2348), price = 25000},
    {coords = vector3(222.9197, -1702.7635, 29.6950), price = 25000},
    {coords = vector3(151.5635, -72.6534, 71.8602), price = 20000},
    {coords = vector3(5.8142, -9.2191, 70.1162), price = 35000},
    {coords = vector3(930.7355, -245.1552, 69.0028), price = 40000},
    {coords = vector3(1258.9746, -1761.5757, 49.6583), price = 30000},
    {coords = vector3(1230.7291, -1590.9597, 53.7661), price = 35000},
    {coords = vector3(-830.6603, 115.0213, 55.8298), price = 650000},
    {coords = vector3(-998.0771, 157.7113, 62.3191) ,price = 550000},
    {coords = vector3(-902.5498, 191.4798, 69.4461), price = 750000},
    {coords = vector3(-1570.6803, 22.7236, 59.5539), price = 550000},
    {coords = vector3(-1467.4543, 35.1820, 54.5448), price = 750000}
}

Citizen.CreateThread(function()
    local blips = {}
    local markers = {}

    for _, location in pairs(houseSaleBlips) do
        DrawMarker(
                    1,
                    location.coords.x,
                    location.coords.y,
                    location.coords.z - 1.0,
                    0.0, 0.0, 0.0,
                    0, 0, 0,
                    3.0, 3.0, 3.0,
                    0, 191, 255, 255,
                    false, false, true, 2, false, nil, nil, false
                )
        local blip = AddBlipForCoord(location.coords.x, location.coords.y, location.coords.z + 1.0)
        SetBlipSprite( blip, 350)
        SetBlipScale(blip, 0.8)
        SetBlipColour(blip, 4)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("House For Sale")
        EndTextCommandSetBlipName(blip)
        table.insert(blips, blip)
    end
end)