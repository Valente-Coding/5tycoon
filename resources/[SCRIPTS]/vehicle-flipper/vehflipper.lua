

-- MISSING TO FIX MONEY ADD CASH WHEN SELLING STOLEN VEHICLES


local MenuDisplay = false
local OnMission = false
local stolenVehs = {}
local stolenVehsSpawn = {x = 144.3575, y = -3210.1628, z = 5.1971, h = 270.3898}

local Location = {
    {coords = vector4(153.1738, -3210.4968, 5.9097, 89.5784)}
}

local EasyVehicleLocations = {
    {coords = vector4(-818.5015, -1091.0413, 10.3347, 119.9965)},
    {coords = vector4(-790.7832, 39.9004, 47.7563, 74.3868)},
    {coords = vector4(71.4832, -33.1596, 68.1750, 339.3123)},
    {coords = vector4(27.2624, -978.9537, 28.7685, 249.6403)},
    {coords = vector4(-497.7236, -70.3512, 38.8493, 326.0300)},
    {coords = vector4(254.4753, 162.2672, 104.0355, 249.1896)},
    {coords = vector4(64.6115, 456.6491, 146.1771, 39.0683)},
    {coords = vector4(226.0028, 681.0536, 188.8300, 106.0895)},
    {coords = vector4(647.7633, 628.9641, 128.2737, 69.5553)},
    {coords = vector4(-606.7789, 865.6842, 212.5394, 161.8913)},
    {coords = vector4(-555.3591, 832.8848, 197.7583, 166.9886)},
    {coords = vector4(-2314.9670, 290.5556, 168.8299, 293.1774)},
    {coords = vector4(-1441.2034, -366.7558, 42.9670, 215.2170)},
    {coords = vector4(-2044.6530, -455.3885, 10.7592, 140.9925)},
    {coords = vector4(-1582.9244, -1028.3257, 12.3817, 24.8044)},
    {coords = vector4(668.5217, -2640.6057, 5.4432, 0.7478)},
}

local HardVehicleLocations = {
    {coords = vector4(199.9001, -2028.8062, 17.6482, 161.5711), npcs = {vector4(202.7246, -2027.2959, 18.2661, 208.7785),vector4(204.4012, -2027.7960, 18.2596, 108.8660), vector4(203.1622, -2029.6100, 18.2925, 7.3867)}},
    {coords = vector4(363.1798, -1670.0901, 42.4065, 49.0696), npcs = {vector4(362.6790, -1671.7915, 43.0438, 77.0437), vector4(360.8435, -1671.8005, 43.0437, 257.1735), vector4(362.4056, -1667.3652, 43.0437, 345.4778)}},
    {coords = vector4(-82.9834, -1405.4789, 28.6833, 271.2635), npcs = {vector4(-83.0971, -1402.7015, 29.3208, 212.9687), vector4(-81.4053, -1403.5310, 29.3208, 94.2027), vector4(-85.7293, -1405.5100, 29.3208, 266.0468)}},
    {coords = vector4(1385.0294, -745.9464, 66.4447, 326.0654), npcs = {vector4(1388.4906, -746.3577, 67.1903, 207.4235), vector4(1390.0955, -749.6818, 67.1903, 28.6896), vector4(1372.8737, -763.1802, 67.1321, 163.2885)}},
    {coords = vector4(2796.6064, -698.8752, 3.0360, 253.8456), npcs = {vector4(2796.2390, -690.3908, 4.4366, 344.9203), vector4(2798.2395, -689.2492, 4.1873, 70.4248), vector4(2796.6909, -687.5040, 4.5100, 184.6784)}},
    {coords = vector4(1129.3296, -2368.2813, 30.3668, 147.0361), npcs = {vector4(1123.4502, -2369.9592, 30.8875, 302.0288), vector4(1124.8254, -2366.7864, 30.8805, 184.7339), vector4(1126.7235, -2362.0801, 30.9016, 312.6748)}},
    {coords = vector4(-242.5733, -2101.6438, 26.9832, 206.5436), npcs = {vector4(-239.1583, -2107.8313, 27.7554, 212.1308), vector4(-237.9704, -2107.1843, 27.7554, 201.3325), vector4(-236.5711, -2106.4380, 27.7554, 207.9979)}},
    {coords = vector4(-967.1973, -1478.1769, 4.3850, 289.8616), npcs = {vector4(-958.6839, -1475.3220, 5.1691, 108.7931), vector4(-960.5351, -1476.1057, 5.1703, 287.0573), vector4(-956.2502, -1485.6366, 5.1646, 157.0361)}},
    {coords = vector4(-184.0716, -177.1332, 42.9876, 340.7763), npcs = {vector4(-180.1276, -167.4342, 44.0323, 329.8930), vector4(-177.8223, -166.5291, 44.0323, 91.2154), vector4(-180.0253, -165.6486, 44.0323, 209.5989)}},
    {coords = vector4(108.2685, -1402.4930, 28.6411, 143.4086), npcs = {vector4(116.0644, -1400.6720, 29.3984, 100.9257), vector4(115.2308, -1398.2841, 29.3979, 114.9798), vector4(95.7116, -1416.4624, 29.4214, 320.9327)}},
    {coords = vector4(-175.8213, -1345.1407, 30.6584, 270.1114), npcs = {vector4(-170.3889, -1346.3005, 31.2959, 179.9205), vector4(-172.4193, -1348.0897, 31.2959, 89.2860), vector4(-185.2578, -1353.9028, 31.3327, 319.7995)}},
    {coords = vector4(28.1807, -1031.9308, 28.7648, 250.4641), npcs = {vector4(35.1716, -1031.6838, 29.5045, 87.4319), vector4(33.3604, -1031.8990, 29.4894, 273.5367), vector4(35.3788, -1037.4923, 29.4546, 157.0378)}},
    {coords = vector4(158.2903, -1081.1292, 28.5552, 178.8933), npcs = {vector4(166.2881, -1087.8325, 29.1924, 274.1446), vector4(158.8787, -1086.8102, 29.1924, 359.9329), vector4(159.6028, -1081.2001, 29.1924, 267.1858)}},
    {coords = vector4(13.9035, -1105.8101, 37.5156, 70.5684), npcs = {vector4(11.1903, -1112.7484, 38.1518, 159.2090), vector4(14.6852, -1112.2166, 38.1518, 65.9844), vector4(17.5049, -1103.9011, 38.1518, 68.4270)}},
    {coords = vector4(-237.0654, -1476.9645, 30.7833, 320.9721), npcs = {vector4(-243.6708, -1474.7335, 31.4611, 251.5539), vector4(-239.1727, -1479.4884, 31.4137, 138.3381), vector4(-240.1199, -1480.6602, 31.5533, 314.2562)}},
    {coords = vector4(-702.9885, -1139.2782, 9.9753, 218.9595), npcs = {vector4(-699.7304, -1142.4229, 10.8126, 133.1821), vector4(-700.5660, -1143.1658, 10.8126, 308.6133), vector4(-705.7286, -1139.8881, 10.8126, 37.5347)}},
}


local EasyVehicles = {
        {model = "comet6", price = 150000, label = "Comet S2"},
        {model = "deity", price = 200000, label = "Vapid Deity"},
        {model = "turismo2", price = 300000, label = "Turismo Classic"},
        {model = "torero2", price = 850000, label = "Grotti Torero"},
        {model = "cypher", price = 110000, label = "Annis Cypher"},
        {model = "sc1", price = 150000, label = "Cheval SC1"},
        {model = "schlagen", price = 130000, label = "Benefactor Schlagen GT"},
        {model = "sm722", price = 530000, label = "Grotti SM 722"},
        {model = "jugular", price = 80000, label = "Ocelot Jugular"},
        {model = "italirsx", price = 800000, label = "Grotti Itali RSX"},
        {model = "vstr", price = 120000, label = "Lampadati V-STR"},
        {model = "mamba", price = 250000, label = "Declasse Mamba"},
        {model = "jester4", price = 90000, label = "Dinka Jester Classic"},
        {model = "bobcatxl", price = 50000, label = "Vapid Bobcat XL"},
        {model = "caracara2", price = 65000, label = "Vapid Caracara 4x4"},
        {model = "chino", price = 25000, label = "Vapid Chino"},
        {model = "dominator", price = 70000, label = "Vapid Dominator"},
        {model = "dominator8", price = 130000, label = "Vapid Dominator GTX"},
        {model = "dominator3", price = 140000, label = "Vapid Dominator ASP"},
        {model = "fmj", price = 500000, label = "Vapid FMJ"},
        {model = "retinue2", price = 35000, label = "Vapid Retinue Mk II"},
        {model = "hustler", price = 95000, label = "Vapid Hustler"},
        {model = "huntley", price = 60000, label = "Enus Huntley S"},
        {model = "hotknife", price = 105000, label = "Vapid Hotknife"},
        {model = "gb200", price = 130000, label = "Vapid GB200"},
        {model = "emerus", price = 220000, label = "Progen Emerus"},
        {model = "t20", price = 120000, label = "Progen T20"},
        {model = "flashgt", price = 90000, label = "Vapid Flash GT"},
        {model = "gp1", price = 1200000, label = "Progen GP1"},
        {model = "locust", price = 160000, label = "Ocelot Locust"},
        {model = "penetrator", price = 940000, label = "Ocelot Penetrator"},
        {model = "rhinehart", price = 120000, label = "Übermacht RH8R"},
        {model = "revolter", price = 190000, label = "Übermacht Revolter"},
        {model = "entityxf", price = 750000, label = "Progen Entity XF"},
        {model = "infernus2", price = 1300000, label = "Pegassi Infernus Classic"},
        {model = "sultan", price = 85000, label = "Karin Sultan Classic"},
        {model = "elegy", price = 160000, label = "Annis Elegy RH8"},
        {model = "sentinel4", price = 150000, label = "Übermacht Sentinel Classic"},

        {model = "brioso3", price = 55000, label = "Grotti Brioso 300"},
        {model = "club", price = 30000, label = "Bürgerfahrzeug Club"},
        {model = "kanjo", price = 60000, label = "Dinka Kanjo"},
        {model = "asbo", price = 20000, label = "Weeny Issi Asbo"},
        {model = "blista", price = 15000, label = "Dinka Blista"},
        {model = "issi3", price = 25000, label = "Weeny Issi"},
        {model = "rhapsody", price = 15000, label = "DeClasse Rhapsody"},
    
        {model = "kanjosj", price = 50000, label = "Dinka Kanjo"},
        {model = "postlude", price = 40000, label = "Mammoth Postlude"},
        {model = "previon", price = 65000, label = "Ubermacht Previon"},
        {model = "windsor2", price = 120000, label = "Enus Windsor Drop"},
        {model = "windsor", price = 130000, label = "Enus Windsor"},
        {model = "zion2", price = 45000, label = "Ubermacht Zion Cabrio"},
        {model = "sentinel", price = 60000, label = "Übermacht Sentinel"},
        {model = "sentinel2", price = 70000, label = "Übermacht Sentinel XS"},
        {model = "oracle2", price = 70000, label = "Übermacht Oracle XS"},
        {model = "f620", price = 95000, label = "Ocelot F620"},
        {model = "cogcabrio", price = 65000, label = "Enus Cognoscenti Cabrio"},
        {model = "exemplar", price = 60000, label = "Dewbauchee Exemplar"},
    
        {model = "powersurge", price = 60000, label = "Lectro Powersurge"},
        {model = "reever", price = 65000, label = "Lectro Reefer"},
        {model = "shinobi", price = 45000, label = "Nagasaki Shinobi"},
        {model = "stryder", price = 30000, label = "Nagasaki Stryder"},
        {model = "rrocket", price = 100000, label = "Nagasaki Shotaro"},
        {model = "fcr2", price = 85000, label = "Pegassi FCR 1000 Custom"},
        {model = "fcr", price = 75000, label = "Pegassi FCR 1000"},
        {model = "diablous2", price = 95000, label = "Principe Diabolus Custom"},
        {model = "diablous", price = 80000, label = "Principe Diabolus"},
        {model = "esskey", price = 25000, label = "Pegassi Esskey"},
        {model = "vortex", price = 35000, label = "Pegassi Vortex"},
        {model = "hakuchou2", price = 120000, label = "Shitzu Hakuchou Drag"},
        {model = "defiler", price = 40000, label = "Shitzu Hakuchou"},
        {model = "chimera", price = 110000, label = "Nagasaki Chimera"},
        {model = "lectro", price = 30000, label = "Principe Lectro"},
        {model = "hakuchou", price = 65000, label = "Shitzu Hakuchou"},
        {model = "thrust", price = 20000, label = "Dinka Thrust"},
        {model = "vader", price = 25000, label = "Shitzu Vader"},
        {model = "ruffian", price = 35000, label = "Pegassi Ruffian"},
        {model = "pcj", price = 25000, label = "Shitzu PCJ 600"},
        {model = "nemesis", price = 35000, label = "Principe Nemesis"},
        {model = "double", price = 50000, label = "Dinka Double-T"},
        {model = "carbonrs", price = 65000, label = "Nagasaki Carbon RS"},
        {model = "bati2", price = 100000, label = "Pegassi Bati 801RR"},
        {model = "bati", price = 80000, label = "Pegassi Bati 801"},
        {model = "akuma", price = 25000, label = "Dinka Akuma"},
        {model = "faggio3", price = 25000, label = "Pegassi Faggio Mod"},
        {model = "faggio", price = 6000, label = "Pegassi Faggio"},
        {model = "faggio2", price = 12000, label = "Pegassi Faggio Sport"},

        {model = "buffalo5", price = 130000, label = "Bravado Buffalo S"},
        {model = "tahoma", price = 40000, label = "Declasse Tahoma"},
        {model = "weevil2", price = 75000, label = "BF Weevil"},
        {model = "vigero2", price = 65000, label = "Declasse Vigero"},
        {model = "ruiner4", price = 65000, label = "Imponte Ruiner 2000"},
        {model = "buffalo4", price = 75000, label = "Bravado Buffalo"},
        {model = "dominator7", price = 65000, label = "Vapid Dominator GTX"},
        {model = "yosemite2", price = 120000, label = "Declasse Yosemite Rancher"},
        {model = "gauntlet4", price = 85000, label = "Bravado Gauntlet Classic Custom"},
        {model = "deviant", price = 55000, label = "Schyster Deviant"},
        {model = "tulip", price = 35000, label = "Declasse Tulip"},
        {model = "imperator", price = 120000, label = "Imponte Imperator"},
        {model = "ellie", price = 150000, label = "Vapid Ellie"},
        {model = "hermes", price = 35000, label = "Albany Hermes"},
        {model = "yosemite", price = 65000, label = "Declasse Yosemite"},
        {model = "sabregt2", price = 70000, label = "Declasse Sabre Turbo Custom"},
        {model = "virgo2", price = 60000, label = "Albany Virgo Classic Custom"},
        {model = "nightshade", price = 90000, label = "Imponte Nightshade"},
        {model = "moonbeam2", price = 50000, label = "Declasse Moonbeam Custom"},
        {model = "faction2", price = 75000, label = "Willard Faction Custom Donk"},
        {model = "chino2", price = 65000, label = "Vapid Chino Custom"},
        {model = "buccaneer2", price = 80000, label = "Albany Buccaneer Custom"},
        {model = "coquette3", price = 95000, label = "Invetero Coquette D10"},
        {model = "chino", price = 45000, label = "Vapid Chino"},
        {model = "slamvan", price = 45000, label = "Vapid Slamvan"},
        {model = "ratloader2", price = 50000, label = "Bravado Rat-Loader"},
        {model = "stalion", price = 40000, label = "Chrysler (Plymouth) Stallion"},
        {model = "picador", price = 40000, label = "Cheval Picador"},
        {model = "phoenix", price = 45000, label = "Imponte Phoenix"},

        {model = "baller", price = 45000, label = "Gallivanter Baller"},
        {model = "bf400", price = 25000, label = "Nagasaki BF400"},
        {model = "bifta", price = 30000, label = "BF Bifta"},
        {model = "blazer", price = 15000, label = "Nagasaki Blazer"},
        {model = "boor", price = 35000, label = "Dundreary Landstalker"},
        {model = "brawler", price = 40000, label = "Coil Brawler"},
        {model = "draugur", price = 50000, label = "Annis ZR380 Draugur"},
        {model = "dubsta3", price = 60000, label = "Benefactor Dubsta 6x6"},
        {model = "dune", price = 20000, label = "MTL Dune"},
        {model = "everon", price = 50000, label = "Karin Everon"},
        {model = "freecrawler", price = 60000, label = "Canis Freecrawler"},
        {model = "guardian", price = 80000, label = "Vapid Guardian"},
        {model = "hellion", price = 45000, label = "Annis Hellion"},
        {model = "blazer3", price = 35000, label = "Nagasaki Hot Rod Blazer"},
        {model = "bfinjection", price = 30000, label = "BF Injection"},
        {model = "kalahari", price = 35000, label = "Canis Kalahari"},
        {model = "kamacho", price = 60000, label = "Vapid Kamacho"},
        {model = "marshall", price = 100000, label = "Cheval Marshall"},
        {model = "outlaw", price = 45000, label = "Nagasaki Outlaw"},
        {model = "patriot", price = 65000, label = "Mammoth Patriot"},
        {model = "rancherxl", price = 40000, label = "Declasse Rancher XL"},
        {model = "rebel2", price = 40000, label = "Karin Rebel"},
        {model = "riata", price = 50000, label = "Vapid Riata"},
        {model = "sanchez2", price = 25000, label = "Maibatsu Sanchez"},
        {model = "sandking", price = 45000, label = "Vapid Sandking XL"},
        {model = "blazer4", price = 45000, label = "Nagasaki Street Blazer"},
        {model = "vagrant", price = 45000, label = "Dundreary Vagrant"},
        {model = "yosemite3", price = 55000, label = "Declasse Yosemite Drift"},

        {model = "asea", price = 15000, label = "DeClasse Asea"},
        {model = "asterope", price = 26000, label = "Karin Asterope"},
        {model = "cinquemila", price = 125000, label = "Karin 500"},
        {model = "cognoscenti", price = 45000, label = "Enus Cognoscenti"},
        {model = "cog55", price = 60000, label = "Enus Cognoscenti 55"},
        {model = "glendale2", price = 40000, label = "Benefactor Glendale Custom"},
        {model = "primo2", price = 60000, label = "Albany Primo Custom"},
        {model = "schafter2", price = 50000, label = "Benefactor Schafter"},
        {model = "schafter3", price = 65000, label = "Benefactor Schafter V12"},
        {model = "stafford", price = 250000, label = "Enus Stafford"},
        {model = "stratum", price = 15000, label = "Zirconium Stratum"},
        {model = "superd", price = 300000, label = "Ubermacht Sentinel Classic"},
        {model = "surge", price = 35000, label = "Cheval Surge"},
        {model = "tailgater", price = 30000, label = "Obey Tailgater"},
        {model = "tailgater2", price = 65000, label = "Obey Tailgater S"},
        {model = "warrener", price = 25000, label = "Vulcar Warrener"},
        {model = "warrener2", price = 35000, label = "Vulcar Warrener HKR"},
        {model = "washington", price = 20000, label = "Albany Washington"},

        {model = "astron2", price = 125000, label = "Albany Astron"},
        {model = "baller", price = 50000, label = "Gallivanter Baller"},
        {model = "baller2", price = 65000, label = "Gallivanter Baller Sport"},
        {model = "baller3", price = 75000, label = "Gallivanter Baller LE"},
        {model = "baller4", price = 70000, label = "Gallivanter Baller LE LWB"},
        {model = "baller7", price = 90000, label = "Gallivanter Baller LE (Armored)"},
        {model = "bjxl", price = 45000, label = "Ubermacht Oracle XS"},
        {model = "cavalcade2", price = 55000, label = "Albany Cavalcade"},
        {model = "contender", price = 60000, label = "Vapid Contender"},
        {model = "dubsta2", price = 70000, label = "Benefactor Dubsta"},
        {model = "dubsta3", price = 75000, label = "Benefactor Dubsta 6x6"},
        {model = "fq2", price = 55000, label = "Fathom FQ 2"},
        {model = "granger2", price = 75000, label = "Declasse Granger"},
        {model = "iwagen", price = 75000, label = "Vulcar Ingot Wagon"},
        {model = "jubilee", price = 130000, label = "Ocelot Jubilee"},
        {model = "landstalker2", price = 65000, label = "Dundreary Landstalker"},
        {model = "mesa", price = 45000, label = "Canis Mesa (Merryweather)"},
        {model = "novak", price = 75000, label = "Lampadati Novak"},
        {model = "patriot", price = 60000, label = "Mammoth Patriot"},
        {model = "patriot2", price = 250000, label = "Mammoth Patriot Stretch"},
        {model = "rebla", price = 80000, label = "Ubermacht Rebla GTS"},
        {model = "seminole2", price = 60000, label = "Canis Seminole Frontier"},
        {model = "toros", price = 130000, label = "Pegassi Toros"},
        {model = "xls", price = 45000, label = "Benefactor XLS"},

        {model = "z190", price = 95000, label = "Übermacht Zion Classic"},
        {model = "ardent", price = 130000, label = "Ocelot Ardent"},
        {model = "casco", price = 55000, label = "Lampadati Casco"},
        {model = "cheburek", price = 35000, label = "Rune Cheburek"},
        {model = "cheetah2", price = 150000, label = "Grotti Cheetah Classic"},
        {model = "coquette2", price = 160000, label = "Invetero Coquette Classic"},
        {model = "dynasty", price = 40000, label = "Weeny Dynasty"},
        {model = "fagaloa", price = 45000, label = "Vapid Fagaloa"},
        {model = "gt500", price = 65000, label = "Albany Manana Custom"},
        {model = "infernus2", price = 140000, label = "Pegassi Infernus Classic"},
        {model = "mamba", price = 70000, label = "Declasse Mamba"},
        {model = "michelli", price = 35000, label = "Lampadati Michelli GT"},
        {model = "monroe", price = 85000, label = "Pegassi Monroe"},
        {model = "nebula", price = 45000, label = "Vulcar Nebula Turbo"},
        {model = "peyote3", price = 60000, label = "Vapid Peyote Custom"},
        {model = "rapidgt3", price = 55000, label = "Dewbauchee Rapid GT Classic"},
        {model = "retinue2", price = 45000, label = "Vapid Retinue Mk II"},
        {model = "btype3", price = 160000, label = "Albany Roosevelt Valor"},
        {model = "savestra", price = 75000, label = "Annis Savestra"},
        {model = "stinger", price = 70000, label = "Grotti Stinger"},
        {model = "stingergt", price = 85000, label = "Grotti Stinger GT"},
        {model = "swinger", price = 70000, label = "Ocelot Swinger"},
        {model = "torero", price = 120000, label = "Pegassi Torero"},
        {model = "tornado5", price = 55000, label = "Declasse Tornado Custom"},
        {model = "tornado6", price = 45000, label = "Declasse Tornado Rat Rod"},
        {model = "viseris", price = 95000, label = "Lampadati Viseris"},
        {model = "ztype", price = 500000, label = "Truffade Z-Type"},
        {model = "zion3", price = 45000, label = "Ubermacht Zion Classic"},

        {model = "tenf", price = 130000, label = "Pfister 811"},
        {model = "tenf2", price = 190000, label = "Pfister 811RR"},
        {model = "r300", price = 95000, label = "Ocelot R300"},
        {model = "drafter", price = 120000, label = "Obey Drafter"},
        {model = "ninef", price = 80000, label = "Obey 9F"},
        {model = "ninef2", price = 85000, label = "Obey 9F Cabrio"},
        {model = "banshee", price = 130000, label = "Bravado Banshee"},
        {model = "bestiagts", price = 160000, label = "Grotti Bestia GTS"},
        {model = "blista2", price = 25000, label = "Dinka Blista Compact"},
        {model = "buffalo2", price = 75000, label = "Bravado Buffalo S"},
        {model = "calico", price = 40000, label = "Vapid Calico GTF"},
        {model = "carbonizzare", price = 80000, label = "Grotti Carbonizzare"},
        {model = "comet2", price = 95000, label = "Pfister Comet"},
        {model = "comet3", price = 140000, label = "Pfister Comet Retro Custom"},
        {model = "comet4", price = 100000, label = "Pfister Comet Safari"},
        {model = "comet5", price = 120000, label = "Pfister Comet SR"},
        {model = "coquette", price = 85000, label = "Invetero Coquette"},
        {model = "coquette4", price = 160000, label = "Invetero Coquette Classic"},
        {model = "corsita", price = 160000, label = "Dinka Jester Classic"},
        {model = "tampa2", price = 200000, label = "Declasse Tampa"},
        {model = "elegy2", price = 120000, label = "Annis Elegy Retro Custom"},
        {model = "euros", price = 80000, label = "Annis Euros"},
        {model = "feltzer2", price = 90000, label = "Benefactor Feltzer"},
        {model = "furoregt", price = 130000, label = "Lampadati Furore GT"},
        {model = "futo", price = 55000, label = "Karin Futo"},
        {model = "futo2", price = 75000, label = "Karin Futo GTX"},
        {model = "growler", price = 130000, label = "Vapid Growler"},
        {model = "imorgon", price = 110000, label = "Overflod Imorgon"},
        {model = "issi7", price = 37000, label = "Weeny Issi Sport"},
        {model = "italigto", price = 170000, label = "Grotti Itali GTO"},
        {model = "stingertt", price = 190000, label = "Grotti Stinger GT"},
        {model = "italirsx", price = 300000, label = "Vapid Retinue Mk II"},
        {model = "jester", price = 90000, label = "Dinka Jester"},
        {model = "jester3", price = 130000, label = "Dinka Jester Classic"},
        {model = "khamelion", price = 125000, label = "Hijak Khamelion"},
        {model = "komoda", price = 85000, label = "Lampadati Komoda"},
        {model = "kuruma", price = 90000, label = "Karin Kuruma"},
        {model = "coureur", price = 80000, label = "Vapid Retinue"},
        {model = "massacro", price = 90000, label = "Dewbauchee Massacro"},
        {model = "neo", price = 150000, label = "Vapid Dominator GTT"},
        {model = "neon", price = 130000, label = "Pfister Neon"},
        {model = "omnis", price = 160000, label = "Hijak Ruston"},
        {model = "omnisegt", price = 190000, label = "Hijak Ruston GTS"},
        {model = "panthere", price = 75000, label = "Übermacht Zion Classic"},
        {model = "paragon", price = 230000, label = "Enus Paragon R"},
        {model = "pariah", price = 130000, label = "Ocelot Pariah"},
        {model = "penumbra2", price = 65000, label = "Maibatsu Penumbra FF"},
        {model = "raiden", price = 100000, label = "Coil Raiden"},
        {model = "raptor", price = 65000, label = "BF Raptor"},
        {model = "revolter", price = 140000, label = "Übermacht Revolter"},
        {model = "rt3000", price = 80000, label = "Annis RT3000"},
        {model = "ruston", price = 120000, label = "Hijak Ruston"},
        {model = "sentinel3", price = 130000, label = "Ubermacht Sentinel XS"},
        {model = "seven70", price = 140000, label = "Dewbauchee Seven-70"},
        {model = "specter2", price = 90000, label = "Dewbauchee Specter Custom"},
        {model = "feltzer3", price = 250000, label = "Benefactor Stirling GT"},
        {model = "sugoi", price = 95000, label = "Dinka Sugoi"},
        {model = "sultan3", price = 125000, label = "Karin Sultan Classic"},
        {model = "vectre", price = 85000, label = "Overflod Vectre"},
        {model = "verlierer2", price = 105000, label = "Bravado Verlierer"},
        {model = "zr350", price = 125000, label = "Annis ZR350"},
        {model = "remus", price = 65000, label = "Annis Remus"},
}

local HardVehicles = {

        {model = "pfister811", price = 200000, label = "Pfister 811"},
        {model = "autarch", price = 350000, label = "Overflod Autarch"},
        {model = "banshee2", price = 160000, label = "Bravado Banshee 900R"},
        {model = "bullet", price = 120000, label = "Vapid Bullet"},
        {model = "champion", price = 170000, label = "Dewbauchee Champion"},
        {model = "cheetah", price = 250000, label = "Grotti Cheetah"},
        {model = "cyclone", price = 150000, label = "Coil Cyclone"},
        {model = "cyclone2", price = 190000, label = "Coil Cyclone II"},
        {model = "deveste", price = 360000, label = "Principe Deveste Eight"},
        {model = "entity3", price = 420000, label = "Ocelot XA-21"},
        {model = "entityxf", price = 220000, label = "Ocelot Entity XF"},
        {model = "entity2", price = 290000, label = "Ocelot Entity XXR"},
        {model = "sheava", price = 250000, label = "Pegassi Tezeract"},
        {model = "furia", price = 360000, label = "Grotti Furia"},
        {model = "ignus", price = 660000, label = "Coil Ignus"},
        {model = "infernus", price = 160000, label = "Pegassi Infernus"},
        {model = "italigtb", price = 280000, label = "Pegassi Itali GTB"},
        {model = "italigtb2", price = 300000, label = "Pegassi Itali GTB Custom"},
        {model = "krieger", price = 590000, label = "Benefactor Krieger"},
        {model = "lm87", price = 750000, label = "Ocelot Lynx"},
        {model = "nero", price = 1200000, label = "Truffade Nero"},
        {model = "nero2", price = 1800000, label = "Truffade Nero Custom"},
        {model = "osiris", price = 850000, label = "Pegassi Osiris"},
        {model = "reaper", price = 320000, label = "Progen Reaper"},
        {model = "le7b", price = 850000, label = "Dewbauchee Vagner"},
        {model = "s80", price = 790000, label = "Lampadati Tigon"},
        {model = "sultanrs", price = 260000, label = "Karin Sultan RS"},
        {model = "taipan", price = 520000, label = "Cheval Taipan"},
        {model = "tempesta", price = 300000, label = "Pegassi Tempesta"},
        {model = "tezeract", price = 2500000, label = "Pegassi Tezeract"},
        {model = "thrax", price = 2300000, label = "Truffade Thrax"},
        {model = "tigon", price = 1000000, label = "Lampadati Tigon"},
        {model = "turismor", price = 950000, label = "Grotti Turismo R"},
        {model = "tyrant", price = 1500000, label = "Overflod Tyrant"},
        {model = "tyrus", price = 1600000, label = "Progen Tyrus"},
        {model = "vacca", price = 210000, label = "Pegassi Vacca"},
        {model = "vagner", price = 1800000, label = "Dewbauchee Vagner"},
        {model = "virtue", price = 1200000, label = "Ocelot Ardent"},
        {model = "visione", price = 1300000, label = "Grotti Visione"},
        {model = "voltic", price = 150000, label = "Coil Voltic"},
        {model = "prototipo", price = 2600000, label = "Pegassi Tempesta"},
        {model = "xa21", price = 430000, label = "Ocelot XA-21"},
        {model = "zeno", price = 660000, label = "Pegassi Zentorno"},
        {model = "zentorno", price = 760000, label = "Pegassi Zentorno"},
        {model = "zorrusso", price = 720000, label = "Pegassi Zorrusso"},
}


local buyersListCoords = {

    {x = 788.7515, y = -790.6373, z = 26.3884, h = 90.8662},
    {x = 44.0986, y = -104.6463, z = 55.9843, h = 340.0691},
    {x = -724.7953, y = -1061.0719, z = 12.3737, h = 67.4136},
    {x = -1087.4849, y = -322.4897, z = 37.6737, h = 15.8140},
    {x = 248.5375, y = -1993.3687, z = 20.2515, h = 14.5749},
    {x = 980.0082, y = -1829.6621, z = 31.3490, h = 350.8308},
    {x = -626.4448, y = -2200.2981, z = 5.9975, h = 194.2748},
    {x = -279.0907, y = -611.6411, z = 33.4631, h = 184.0482},
    {x = -428.9567, y = -328.8341, z = 33.5241, h = 252.6558}

}



local NpcModels = {
    "a_m_m_afriamer_01",
    "a_m_m_beach_01",
    "a_m_m_beach_02",
    "a_m_m_bevhills_01",
    "a_m_m_bevhills_02",
    "a_m_m_business_01",
    "a_m_m_eastsa_01",
    "a_m_m_eastsa_02",
    "a_m_m_farmer_01",
    "a_m_m_fatlatin_01",
    "a_m_m_genfat_01",
    "a_m_m_genfat_02",
    "a_m_m_golfer_01",
    "a_m_m_hasjew_01",
    "a_m_m_hillbilly_01",
    "a_m_m_hillbilly_02",
    "a_m_m_indian_01",
    "a_m_m_ktown_01",
    "a_m_m_malibu_01",
    "a_m_m_mexcntry_01",
    "a_m_m_mexlabor_01",
    "a_m_m_og_boss_01",
    "a_m_m_paparazzi_01",
    "a_m_m_polynesian_01",
    "a_m_m_prolhost_01",
    "a_m_m_rurmeth_01",
    "a_m_m_salton_01",
    "a_m_m_salton_02",
    "a_m_m_salton_03",
    "a_m_m_salton_04",
    "a_m_m_skater_01",
    "a_m_m_skidrow_01",
    "a_m_m_socenlat_01",
    "a_m_m_soucent_01",
    "a_m_m_soucent_02",
    "a_m_m_soucent_03",
    "a_m_m_soucent_04",
    "a_m_m_stlat_02",
    "a_m_m_tennis_01",
    "a_m_m_tourist_01",
    "a_m_m_tramp_01",
    "a_m_m_trampbeac_01",
    "a_m_m_tranvest_01",
    "a_m_m_tranvest_02",
    "a_m_o_acult_01",
    "a_m_o_acult_02",
    "a_m_o_beach_01",
    "a_m_o_genstreet_01",
    "a_m_o_ktown_01",
    "a_m_o_salton_01",
    "a_m_o_soucent_01",
    "a_m_o_soucent_02",
    "a_m_o_soucent_03",
    "a_m_o_tramp_01",
    "a_m_y_acult_01",
    "a_m_y_acult_02",
    "a_m_y_beach_01",
    "a_m_y_beach_02",
    "a_m_y_beach_03",
    "a_m_y_beachvesp_01",
    "a_m_y_beachvesp_02",
    "a_m_y_bevhills_01",
    "a_m_y_bevhills_02",
    "a_m_y_breakdance_01",
    "a_m_y_busicas_01",
    "a_m_y_business_01",
    "a_m_y_business_02",
    "a_m_y_business_03",
    "a_m_y_cyclist_01",
    "a_m_y_dhill_01",
    "a_m_y_downtown_01",
    "a_m_y_eastsa_01",
    "a_m_y_eastsa_02",
    "a_m_y_epsilon_01",
    "a_m_y_epsilon_02",
    "a_m_y_gay_01",
    "a_m_y_gay_02",
    "a_m_y_genstreet_01",
    "a_m_y_genstreet_02",
    "a_m_y_golfer_01",
    "a_m_y_hasjew_01",
    "a_m_y_hiker_01",
    "a_m_y_hippy_01",
    "a_m_y_hipster_01",
    "a_m_y_hipster_02",
    "a_m_y_hipster_03",
    "a_m_y_indian_01",
    "a_m_y_jetski_01",
    "a_m_y_juggalo_01",
    "a_m_y_ktown_01",
    "a_m_y_ktown_02",
    "a_m_y_latino_01",
    "a_m_y_methhead_01",
    "a_m_y_mexthug_01",
    "a_m_y_motox_01",
    "a_m_y_motox_02",
    "a_m_y_musclbeac_01",
    "a_m_y_musclbeac_02",
    "a_m_y_polynesian_01",
    "a_m_y_roadcyc_01",
    "a_m_y_runner_01",
    "a_m_y_runner_02",
    "a_m_y_salton_01",
    "a_m_y_skater_01",
    "a_m_y_skater_02",
    "a_m_y_soucent_01",
    "a_m_y_soucent_02",
    "a_m_y_soucent_03",
    "a_m_y_soucent_04",
    "a_m_y_stbla_01",
    "a_m_y_stbla_02",
    "a_m_y_stlat_01",
    "a_m_y_stwhi_01",
    "a_m_y_stwhi_02",
    "a_m_y_sunbathe_01",
    "a_m_y_surfer_01",
    "a_m_y_vindouche_01",
    "a_m_y_vinewood_01",
    "a_m_y_vinewood_02",
    "a_m_y_vinewood_03",
    "a_m_y_vinewood_04",
    "a_m_y_yoga_01",
}



Citizen.CreateThread(function()

    for _, location in ipairs(Location) do
        local blip = AddBlipForCoord(location.coords.x, location.coords.y, location.coords.z)
        SetBlipSprite(blip, 643)
        SetBlipScale(blip, 0.7)
        SetBlipColour(blip, 1)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Vehicle Flipper")
        EndTextCommandSetBlipName(blip)
        local pedModel = "a_m_m_eastsa_02"
        RequestModel(pedModel)
        while not HasModelLoaded(pedModel) do
            Citizen.Wait(1)
        end
        
        local pedSpawn = CreateBrainlessNpc(pedModel, location.coords.x, location.coords.y, location.coords.z - 1, location.coords.w, false) 
        location.ped = pedSpawn
    end
end)

function CreateBrainlessNpc(pedModel, x , y, z, h, network) 
    local ped = CreatePed(26, GetHashKey(pedModel), x , y, z, h, network, true)
    SetEntityInvincible(ped, true)
    FreezeEntityPosition(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedFleeAttributes(ped, 0, 0)
    SetPedCombatAttributes(ped, 17, 1)
    SetPedSeeingRange(ped, 0.0)
    SetPedHearingRange(ped, 0.0)
    SetPedAlertness(ped, 0)

    return ped
end



function CloseAllMenus(cooldown, stay)
    Citizen.CreateThread(function()   
        if cooldown then
            Citizen.Wait(cooldown)
        end

        if stay then

        else
            MenuDisplay = false
        end
    end)

    TriggerEvent("side-menu:resetOptions")
end




function LoadNPCS(num)
    local npcs = {}

    for i = 1, num do
        local npcModel = NpcModels[math.random(1, #NpcModels)]
        RequestModel(npcModel)
        while not HasModelLoaded(npcModel) do
            Citizen.Wait(1)
        end
        table.insert(npcs, npcModel)
    end
    return npcs
end




function DeliverCar(veh)

    TriggerEvent("vehicle-stats:getProperties", veh, function(properties)
        stolenVehs = json.decode(GetExternalKvpString("save-load", "CHAR_STOLEN_VEHICLES"))
        table.insert(stolenVehs, properties)
        TriggerEvent("save-load:setGlobalVariables", {{name = "CHAR_STOLEN_VEHICLES", type = "string", value = json.encode(stolenVehs)}})
        DeleteVehicle(veh)
        OnMission = false
        TriggerEvent("notification:send", {color = "green", time = 7000, text = "Vehicle has been delivered."})
    end)
    
end

function RemoveCar(veh)
    local found = false
    stolenVehs = json.decode(GetExternalKvpString("save-load", "CHAR_STOLEN_VEHICLES"))
    
    for i, stolenVeh in pairs(stolenVehs) do
        if stolenVeh.plate == veh.plate then 
            table.remove(stolenVehs, i)
            found = true
            break
        end
    end

    if found then
        TriggerEvent("save-load:setGlobalVariables", {{name = "CHAR_STOLEN_VEHICLES", type = "string", value = json.encode(stolenVehs)}})
    end

    return found
end


function StolenVehicleOptions(StolenVehicle)
    local price = GetVehicleModelPrice(StolenVehicle.model)
    local ops = {
        {id = "sell", label = "Sell Vehicle", quantity = "$" .. price * 0.1, cb = function() SellVehicle(StolenVehicle) end},
        {id = "legalize", label = "Legalize Vehicle", quantity = "-$" .. price * 0.2, cb = function() LegalizeCar(StolenVehicle) end},
        {id = "cancel", label = "Cancel", quantity = "", cb = function() CloseAllMenus() end}
    }

    TriggerEvent("side-menu:addOptions", ops)

end


function DisplayStolenVehs()
    
    local stolenVehs = json.decode(GetExternalKvpString("save-load", "CHAR_STOLEN_VEHICLES"))
    local ops = {}

    for _, stolenVeh in pairs(stolenVehs) do 
        local vehName = GetVehicleModelName(stolenVeh.model)
        table.insert(ops, {id = "stolen_veh_"..stolenVeh.plate, label = vehName, quantity = "", cb = function() CloseAllMenus(0, true) StolenVehicleOptions(stolenVeh) end})
    end

    TriggerEvent("side-menu:addOptions", ops)
end


function GetVehicleModelPrice(model)
    local vehModelName = GetDisplayNameFromVehicleModel(model)
    vehModelName = string.lower(vehModelName)
    
    for _, easyVeh in pairs(EasyVehicles) do
        if easyVeh.model == vehModelName then 
            return easyVeh.price
        end
    end

    for _, hardVeh in pairs(HardVehicles) do
        if hardVeh.model == vehModelName then 
            return hardVeh.price
        end
    end

    return "NOT FOUND"
end


function GetVehicleModelName(model)
    local vehModelName = GetDisplayNameFromVehicleModel(model)
    vehModelName = string.lower(vehModelName)
    
    for _, easyVeh in pairs(EasyVehicles) do
        if easyVeh.model == vehModelName then 
            return easyVeh.label
        end
    end

    for _, hardVeh in pairs(HardVehicles) do
        if hardVeh.model == vehModelName then 
            return hardVeh.label
        end
    end

    return "NOT FOUND"
end


function SpawnVehicle(data, x, y, z, h)
    RequestModel(data["model"])
    while not HasModelLoaded(data["model"]) do
        Citizen.Wait(1)
    end

    local veh = CreateVehicle(data["model"], x, y, z, h, true, true)
	if veh then 
    	TriggerEvent("vehicle-stats:loadProperies", veh, data)
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)

        return veh
	end
end


function SellVehicle(veh)
    
    CloseAllMenus()

    local spawnedVeh = SpawnVehicle(veh.properties, stolenVehsSpawn.x, stolenVehsSpawn.y, stolenVehsSpawn.z, stolenVehsSpawn.h)

    TriggerEvent("notification:send", {color = "green", time = 7000, text = "Deliver the vehicle to the buyer."})
    
    StolenVehBuyer = buyersListCoords[math.random(1, #buyersListCoords)]
    StolenVehBuyerCoords = vector3(StolenVehBuyer.x, StolenVehBuyer.y, StolenVehBuyer.z)
    
    local buyerNPC = CreateBrainlessNpc(LoadNPCS(1)[1], StolenVehBuyerCoords.x, StolenVehBuyerCoords.y, StolenVehBuyerCoords.z - 1, StolenVehBuyer.h, true)

    TriggerEvent("waypointer:add", 
            "buyerForStolenVeh", --waypointer name
            {
                coords = nil,
                entity = buyerNPC,
                sprite = 47, scale = 0.7, 
                short = true, 
                color = 46, 
                label = "Buyer"
            }, 
            {
                coords = nil, 
                color = 46, 
                onFoot = false, 
                radarThick = 16, 
                mapThick = 16, 
                range = 10, 
                removeBlip = true
            }
        )

    TriggerEvent("waypointer:setroute", "buyerForStolenVeh")

    while #(GetEntityCoords(PlayerPedId()) - StolenVehBuyerCoords) > 10.0 do
        Citizen.Wait(100)
    end

    local price = GetVehicleModelPrice(veh.model) * 0.1

    TriggerEvent("bank:changeCash", tonumber(price))

    SetVehicleBrake(spawnedVeh, true)

    -- make player get out of the vehicle and make vehicle not enterable by player

    SetVehicleDoorsLockedForAllPlayers(spawnedVeh, true)
    TaskLeaveVehicle(PlayerPedId(), spawnedVeh, 0)
    Citizen.Wait(1000)
    
    FreezeEntityPosition(buyerNPC, false)
    TaskEnterVehicle(buyerNPC, spawnedVeh, -1, -1, 1.0, 1, 0)

    SetVehicleBrake(spawnedVeh, false)

    if RemoveCar(veh) then 
        TriggerEvent("notification:send", {color = "green", time = 7000, text = "Vehicle sold for $" .. price})
    end
    
    Citizen.Wait(1000)
    SetDriverAbility(ped, 1.0)
    SetDriverAggressiveness(ped, 0.0)
    TaskVehicleDriveWander(buyerNPC, spawnedVeh, 20.0, 447)
    
    -- if npc and vehicle are over 200 meters away from player, remove NPC and vehicle

    while #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(buyerNPC)) < 200.0 do
        Citizen.Wait(100)
    end

    DeleteEntity(buyerNPC)
    DeleteVehicle(spawnedVeh)

end


function LegalizeCar(veh)
    print("Legalizing vehicle " .. veh.model)
end


function StartMission(difficulty)
    Citizen.CreateThread(function()
        local SpawnPos = nil
        if difficulty == "easy" then
            SpawnPos = EasyVehicleLocations[math.random(1, #EasyVehicleLocations)].coords
            -- Spawn a random vehicle model from the EasyVehicles on the SpawnPos position
            local vehicleModel = EasyVehicles[math.random(1, #EasyVehicles)].model
            RequestModel(vehicleModel)
            while not HasModelLoaded(vehicleModel) do
                Citizen.Wait(1)
            end
            local vehicleSpawn = CreateVehicle(GetHashKey(vehicleModel), SpawnPos.x, SpawnPos.y, SpawnPos.z, SpawnPos.w, true, true)
            SetVehicleOnGroundProperly(vehicleSpawn)
            TriggerEvent("waypointer:add", 
                "vehspawn", --waypointer name
                { --waypointer options
                    coords = nil,
                    entity = vehicleSpawn,
                    sprite = 1, scale = 0.7, 
                    short = false, 
                    color = 5, 
                    label = "Steal car"
                }, 
                {
                    coords = nil, 
                    color = 5, 
                    onFoot = true, 
                    radarThick = 16, 
                    mapThick = 16, 
                    range = 30,
                    removeBlip = true
                }
            )
            TriggerEvent("waypointer:setroute", "vehspawn")
            -- confirm if player is inside vehicle
            while not IsPedInVehicle(PlayerPedId(), vehicleSpawn, false) do
                Citizen.Wait(100)
            end
            -- 50% chance to get 2 cop stars
            if math.random(1, 2) == 1 then
                SetPlayerWantedLevel(PlayerId(), 2, false)
                SetPlayerWantedLevelNow(PlayerId(), false)
            end

            -- get new waypointer to Location
            TriggerEvent("waypointer:add", 
                "vehflip", --waypointer name
                { --waypointer options
                    coords = Location[1].coords,
                    entity = nil,
                    sprite = 1, scale = 0.7, 
                    short = false, 
                    color = 5, 
                    label = "Deliver car"
                }, 
                {
                    coords = Location[1].coords, 
                    color = 5, 
                    onFoot = true, 
                    radarThick = 16, 
                    mapThick = 16, 
                    range = 30,
                    removeBlip = true
                }
            )
            TriggerEvent("waypointer:setroute", "vehflip")
            -- verify if player is within 10 meters from Location
            while #(GetEntityCoords(PlayerPedId()) - vector3(Location[1].coords.x, Location[1].coords.y, Location[1].coords.z)) > 10.0 do
                Citizen.Wait(100)
            end
            
            local alert = false
            while #(GetEntityCoords(PlayerPedId()) - vector3(Location[1].coords.x, Location[1].coords.y, Location[1].coords.z)) > 10.0 or GetPlayerWantedLevel(PlayerId()) > 0 do
                if #(GetEntityCoords(PlayerPedId()) - vector3(Location[1].coords.x, Location[1].coords.y, Location[1].coords.z)) < 10.0 and alert == false then
                    alert = true
                    TriggerEvent("notification:send", {color = "red", time = 7000, text = "You must lose the cops first!"})
                elseif #(GetEntityCoords(PlayerPedId()) - vector3(Location[1].coords.x, Location[1].coords.y, Location[1].coords.z)) > 10.0 and alert == true then
                    alert = false
                end
                Citizen.Wait(100)
            end

                -- confirm if player is inside vehicle
            if IsPedInVehicle(PlayerPedId(), vehicleSpawn, false) then
                -- add a side-menu:addOptions to the player to deliver the car
                TriggerEvent("side-menu:addOptions", {{id = "deliver_stolen_car", label = "Deliver car", cb = function()
                    -- remove the side-menu:addOptions
                    CloseAllMenus()
                    -- remove the vehicle
                    DeliverCar(vehicleSpawn)
                end}})
            end

        elseif difficulty == "hard" then
            SpawnPosAll = HardVehicleLocations[math.random(1, #HardVehicleLocations)]
            SpawnPos = SpawnPosAll.coords
            -- Spawn a random vehicle model from the HardVehicleLocations on the SpawnPos position
            local vehicleModel = HardVehicles[math.random(1, #HardVehicles)].model
            RequestModel(vehicleModel)
            while not HasModelLoaded(vehicleModel) do
                Citizen.Wait(1)
            end
            local vehicleSpawn = CreateVehicle(GetHashKey(vehicleModel), SpawnPos.x, SpawnPos.y, SpawnPos.z, SpawnPos.w, true, true)
            SetVehicleOnGroundProperly(vehicleSpawn)
            
            -- spawn 3 random npc on SpawnPosAll.npc[1], SpawnPosAll.npc[2], SpawnPosAll.npc[3]
            local npcs = LoadNPCS(3)

            local npcSpawn1 = CreatePed(26, GetHashKey(npcs[1]), SpawnPosAll.npcs[1].x, SpawnPosAll.npcs[1].y, SpawnPosAll.npcs[1].z, SpawnPosAll.npcs[1].w, false, true)
            local npcSpawn2 = CreatePed(26, GetHashKey(npcs[2]), SpawnPosAll.npcs[2].x, SpawnPosAll.npcs[2].y, SpawnPosAll.npcs[2].z, SpawnPosAll.npcs[2].w, false, true)
            local npcSpawn3 = CreatePed(26, GetHashKey(npcs[3]), SpawnPosAll.npcs[3].x, SpawnPosAll.npcs[3].y, SpawnPosAll.npcs[3].z, SpawnPosAll.npcs[3].w, false, true)
            
            -- get all 3 npcs pistols
            GiveWeaponToPed(npcSpawn1, GetHashKey("WEAPON_PISTOL"), 255, true, false)
            GiveWeaponToPed(npcSpawn2, GetHashKey("WEAPON_PISTOL"), 255, true, false)
            GiveWeaponToPed(npcSpawn3, GetHashKey("WEAPON_PISTOL"), 255, true, false)
            
            
            -- add a waypointer to the vehicle
            TriggerEvent("waypointer:add", 
                "vehspawnhard", --waypointer name
                { --waypointer options
                    coords = nil,
                    entity = vehicleSpawn,
                    sprite = 1, scale = 0.7, 
                    short = false, 
                    color = 46, 
                    label = "Steal car"
                }, 
                {
                    coords = nil, 
                    color = 5, 
                    onFoot = true, 
                    radarThick = 16, 
                    mapThick = 16, 
                    range = 30,
                    removeBlip = true
                }
            )
            TriggerEvent("waypointer:setroute", "vehspawnhard")
            
            -- check if player is within 5 meter from SpawnPos
            while #(GetEntityCoords(PlayerPedId()) - vector3(SpawnPos.x, SpawnPos.y, SpawnPos.z)) > 5.0 do
                Citizen.Wait(100)
            end
            -- make the npcs attack only the playerPed and not themselves
            SetPedRelationshipGroupHash(npcSpawn1, GetHashKey("PLAYER"))
            SetPedRelationshipGroupHash(npcSpawn2, GetHashKey("PLAYER"))
            SetPedRelationshipGroupHash(npcSpawn3, GetHashKey("PLAYER"))

            -- make the npcs attack the playerPed
            TaskCombatPed(npcSpawn1, PlayerPedId(), 0, 16)
            TaskCombatPed(npcSpawn2, PlayerPedId(), 0, 16)
            TaskCombatPed(npcSpawn3, PlayerPedId(), 0, 16)


            -- check if player is inside vehicle
            while not IsPedInVehicle(PlayerPedId(), vehicleSpawn, false) do
                Citizen.Wait(100)
            end
            -- if player has 2 or more cop stars, do nothing, if it has less, change to 2
            if GetPlayerWantedLevel(PlayerId()) < 2 then
                SetPlayerWantedLevel(PlayerId(), 2, false)
                SetPlayerWantedLevelNow(PlayerId(), false)
            end

            -- get new waypointer to Location
            TriggerEvent("waypointer:add", 
                "deliver-stolen-vehicle-warehouse", --waypointer name
                {
                    coords = Location[1].coords, 
                    entity = nil, -- No need to set coords when using entities
                    sprite = 1, scale = 0.5, 
                    short = true, 
                    color = 46, 
                    label = "Destination"
                }, 
                {
                    coords = Location[1].coords, -- No need to set coords when using entities
                    color = 46, 
                    onFoot = true, 
                    radarThick = 16, 
                    mapThick = 16, 
                    range = 30, 
                    removeBlip = true
                }
            )
            
            TriggerEvent("waypointer:setroute", "vehfliphard")
            -- verify if player is within 10 meters from Location and is inside the car
            local alert = false
            while #(GetEntityCoords(PlayerPedId()) - vector3(Location[1].coords.x, Location[1].coords.y, Location[1].coords.z)) > 10.0 or GetPlayerWantedLevel(PlayerId()) > 0 do
                if #(GetEntityCoords(PlayerPedId()) - vector3(Location[1].coords.x, Location[1].coords.y, Location[1].coords.z)) < 10.0 and alert == false then
                    alert = true
                    TriggerEvent("notification:send", {color = "red", time = 7000, text = "You must lose the cops first!"})
                elseif #(GetEntityCoords(PlayerPedId()) - vector3(Location[1].coords.x, Location[1].coords.y, Location[1].coords.z)) > 10.0 and alert == true then
                    alert = false
                end
                Citizen.Wait(100)
            end

                -- confirm if player is inside vehicle
            if IsPedInVehicle(PlayerPedId(), vehicleSpawn, false) then
                -- add a side-menu:addOptions to the player to deliver the car
                TriggerEvent("side-menu:addOptions", {{id = "deliver_stolen_car", label = "Deliver car", cb = function()
                    -- remove the side-menu:addOptions
                    CloseAllMenus()
                    DeliverCar(vehicleSpawn)
                end}})
            end
        end
    end)
end



Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        for _, location in ipairs(Location) do
            local playerPed = GetPlayerPed(-1)
            local pedCoords = GetEntityCoords(playerPed)
            local distance = #(pedCoords - vector3(location.coords.x, location.coords.y, location.coords.z))
            if distance < 1.5 and MenuDisplay == false and OnMission == false then
                MenuDisplay = true
                TriggerEvent("side-menu:addOptions", {{id = "shaddy_vehicle_dealer", label = "Jobs", cb = function()
                    CloseAllMenus(1, true)
                    if MenuDisplay then
                        TriggerEvent("side-menu:addOptions",
                        {{id = "easy_job_start", label = "Get an easy job", quantity = 20000, cb = function()
                            TriggerEvent("bank:changeCash", -20000, function(check, needAmount)
                                if check then
                                    StartMission("easy")
                                    CloseAllMenus()
                                    OnMission = true
                                else
                                    TriggerEvent("notification:send", {text = "You need $"..needAmount.." cash more to do this job", color = "red", time = 7000})
                                end
                            end)
                        end},
                        {id = "hard_job_start", label = "Get a hard job", cb = function()
                            MenuDisplay = false
                            OnMission = true
                            StartMission("hard")
                            CloseAllMenus()
                        end}})
                    end
                end}})

                stolenVehs = json.decode(GetExternalKvpString("save-load", "CHAR_STOLEN_VEHICLES"))

                if #stolenVehs > 0 then
                    TriggerEvent("side-menu:addOptions", {{id = "check_stolen_vehs", label = "Check stolen vehicles", cb = function()
                        
                        CloseAllMenus(0, true)
                        DisplayStolenVehs()

                    end}})
                end

            elseif distance < 1.5 and MenuDisplay == false and OnMission == true then
                MenuDisplay = true
                TriggerEvent("side-menu:addOptions", {{id = "cancel_mission", label = "Cancel mission", cb = function()
                    CloseAllMenus()
                    OnMission = false
                    MenuDisplay = false
                end}})

            elseif distance < 1.5 and MenuDisplay == false and OnMission == true then
                MenuDisplay = true
                TriggerEvent("side-menu:addOptions", {{id = "cancel_mission", label = "Cancel mission", cb = function()
                    CloseAllMenus()
                    OnMission = false
                    MenuDisplay = false
                end}})
            elseif distance > 2.0 and distance <= 3.0 and MenuDisplay == true then
                CloseAllMenus()
            end
        end
    end
end)