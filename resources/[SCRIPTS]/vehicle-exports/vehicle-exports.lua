local blipExports = vector3(482.7004, -1321.0811, 29.2033)
local heading = 28.1755

local randomCarLocation = {
    vector4(),
    vector4(),
    vector4(),
    vector4(),
    vector4(),
    vector4(),
    vector4(),
    vector4(),
    vector4(),
    vector4()
}


local randomCarModel = {
    {model = "comet6", price = 150000},
    {model = "deity", price = 200000},
    {model = "turismo2", price = 300000},
    {model = "torero2", price = 850000},
    {model = "cypher", price = 110000},
    {model = "sc1", price = 150000},
    {model = "schlagen", price = 130000},
    {model = "sm722", price = 530000},
    {model = "jugular", price = 80000},
    {model = "italirsx", price = 800000},
    {model = "vstr", price = 120000},
    {model = "mamba", price = 250000},
    {model = "jester4", price = 90000},
    {model = "bobcatxl", price = 50000},
    {model = "caracara2", price = 65000},
    {model = "chino", price = 25000},
    {model = "dominator", price = 70000},
    {model = "dominator8", price = 130000},
    {model = "dominator3", price = 140000},
    {model = "fmj", price = 500000},
    {model = "retinue2", price = 35000},
    {model = "hustler", price = 95000},
    {model = "huntley", price = 60000},
    {model = "hotknife", price = 105000},
    {model = "gb200", price = 130000},
    {model = "emerus", price = 220000},
    {model = "t20", price = 120000},
    {model = "flashgt", price = 90000},
    {model = "gp1", price = 1200000},
    {model = "locust", price = 160000},
    {model = "penetrator", price = 940000},
    {model = "rhinehart", price = 120000},
    {model = "revolter", price = 190000},
    {model = "entityxf", price = 750000},
    {model = "infernus2", price = 1300000},
    {model = "sultan", price = 85000},
    {model = "elegy", price = 160000},
    {model = "sentinel4", price = 150000},
    {model = "brioso3", price = 55000},
    {model = "club", price = 30000},
    {model = "kanjo", price = 60000},
    {model = "asbo", price = 20000},
    {model = "blista", price = 15000},
    {model = "issi3", price = 25000},
    {model = "rhapsody", price = 15000},
    {model = "kanjosj", price = 50000},
    {model = "postlude", price = 40000},
    {model = "previon", price = 65000},
    {model = "windsor2", price = 120000},
    {model = "windsor", price = 130000},
    {model = "zion2", price = 45000},
    {model = "sentinel", price = 60000},
    {model = "sentinel2", price = 70000},
    {model = "oracle2", price = 70000},
    {model = "f620", price = 95000},
    {model = "cogcabrio", price = 65000},
    {model = "exemplar", price = 60000},
    {model = "powersurge", price = 60000},
    {model = "reever", price = 65000},
    {model = "shinobi", price = 45000},
    {model = "stryder", price = 30000},
    {model = "rrocket", price = 100000},
    {model = "fcr2", price = 85000},
    {model = "fcr", price = 75000},
    {model = "diablous2", price = 95000},
    {model = "diablous", price = 80000},
    {model = "esskey", price = 25000},
    {model = "vortex", price = 35000},
    {model = "hakuchou2", price = 120000},
    {model = "defiler", price = 40000},
    {model = "chimera", price = 110000},
    {model = "lectro", price = 30000},
    {model = "hakuchou", price = 65000},
    {model = "thrust", price = 20000},
    {model = "vader", price = 25000},
    {model = "ruffian", price = 35000},
    {model = "pcj", price = 25000},
    {model = "nemesis", price = 35000},
    {model = "double", price = 50000},
    {model = "carbonrs", price = 65000},
    {model = "bati2", price = 100000},
    {model = "bati", price = 80000},
    {model = "akuma", price = 25000},
    {model = "buffalo5", price = 130000},
    {model = "tahoma", price = 40000},
    {model = "weevil2", price = 75000},
    {model = "vigero2", price = 65000},
    {model = "ruiner4", price = 65000},
    {model = "buffalo4", price = 75000},
    {model = "dominator7", price = 65000},
    {model = "yosemite2", price = 120000},
    {model = "gauntlet4", price = 85000},
    {model = "deviant", price = 55000},
    {model = "tulip", price = 35000},
    {model = "imperator", price = 120000},
    {model = "ellie", price = 150000},
    {model = "hermes", price = 35000},
    {model = "yosemite", price = 65000},
    {model = "sabregt2", price = 70000},
    {model = "virgo2", price = 60000},
    {model = "nightshade", price = 90000},
    {model = "moonbeam2", price = 50000},
    {model = "faction2", price = 75000},
    {model = "chino2", price = 65000},
    {model = "buccaneer2", price = 80000},
    {model = "coquette3", price = 95000},
    {model = "chino", price = 45000},
    {model = "slamvan", price = 45000},
    {model = "ratloader2", price = 50000},
    {model = "stalion", price = 40000},
    {model = "picador", price = 40000},
    {model = "phoenix", price = 45000},
    {model = "baller", price = 45000},
    {model = "bf400", price = 25000},
    {model = "bifta", price = 30000},
    {model = "blazer", price = 15000},
    {model = "boor", price = 35000},
    {model = "brawler", price = 40000},
    {model = "draugur", price = 50000},
    {model = "dubsta3", price = 60000},
    {model = "dune", price = 20000},
    {model = "everon", price = 50000},
    {model = "freecrawler", price = 60000},
    {model = "guardian", price = 80000},
    {model = "hellion", price = 45000},
    {model = "blazer3", price = 35000},
    {model = "bfinjection", price = 30000},
    {model = "kalahari", price = 35000},
    {model = "kamacho", price = 60000},
    {model = "marshall", price = 100000},
    {model = "outlaw", price = 45000},
    {model = "patriot", price = 65000},
    {model = "rancherxl", price = 40000},
    {model = "rebel2", price = 40000},
    {model = "riata", price = 50000},
    {model = "sanchez2", price = 25000},
    {model = "sandking", price = 45000},
    {model = "blazer4", price = 45000},
    {model = "vagrant", price = 45000},
    {model = "yosemite3", price = 55000},
}



function CreateMapBlip()
    local blip = AddBlipForCoord(blipExports)

    SetBlipSprite(blip, 380)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.7)
    SetBlipColour(blip, 21)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Vehicle Exports")
    EndTextCommandSetBlipName(blip)
    local pedModel = "a_m_m_eastsa_02"
    RequestModel(pedModel)
    while not HasModelLoaded(pedModel) do
        Citizen.Wait(1)
    end
    local pedSpawn = CreatePed(26, GetHashKey(pedModel), blipExports, heading.w, false, true)
    SetEntityInvincible(pedSpawn, true)
end



function GetRandomCar()

    local pickRandom = math.random(1, #randomCarModel)

    local selectedPickupPoint = randomCarModel.model[pickRandom]

    return selectedPickupPoint

end



Citizen.CreateThread(function()
    while true do
        Wait(1)

        -- if playerCanSeeBlip then
        --     CreateMapBlip()
        -- end
        
        -- if playerCanSeeBlip then
        --     ADD CODE FOR NPC TO SPAWN AND ADD JOBS
        -- end
    end
end)