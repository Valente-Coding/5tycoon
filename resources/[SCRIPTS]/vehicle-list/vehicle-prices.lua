--PRICES FOR VEHICLES FOR THE SELL SCRIPT


local vehicles = {

    --#########################
    --#######Dealerships#######
    --#########################

    dealerships = {

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

    },

    --#########################
    --######VirtualDealer######
    --#########################

    ---COMPACTS---


    compats = {

    {model = "brioso3", price = 55000, label = "Grotti Brioso 300"},
    {model = "club", price = 30000, label = "Bürgerfahrzeug Club"},
    {model = "kanjo", price = 60000, label = "Dinka Kanjo"},
    {model = "asbo", price = 20000, label = "Weeny Issi Asbo"},
    {model = "blista", price = 15000, label = "Dinka Blista"},
    {model = "issi3", price = 25000, label = "Weeny Issi"},
    {model = "rhapsody", price = 15000, label = "DeClasse Rhapsody"},

    },


    ---COUPES---

    coupes = {

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

    },


    ---MOTORCYCLES---

    motorcycles = {

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

    },



    ---MUSCLE---


    muscle = {

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

    },


    ---OFF-ROAD---


    offroad = {

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

    },


    ---SEDANS---

    sedans = {

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

    },




    ---SPORTS---

    sports = {

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

    },



    ---SPORTS CLASSIC---


    sportsclassic = {

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

    },



    ---SUPER---

    super = {

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

    },



    ---SUVs---

    suvs = {

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

    },

}