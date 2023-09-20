Config = {}

Config.DefaultVariables = {
    {name = "BANK_BALANCE", type = "int", default = 5000},
    {name = "CASH_BALANCE", type = "int", default = 500},
    {name = "DIRTY_BALANCE", type = "int", default = 500},
    {name = "DIRTY_DISPLAY", type = "int", default = 0},
    {name = "INV_ITEMS", type = "string", default = "{}"},
    {name = "TRUCK_DATA", type = "string", default = "{\"level\": 0, \"jobs\": 0, \"canBuy\": false}"},
    {name = "DELIVERY_DATA", type = "string", default = "{\"level\": 0, \"jobs\": 0, \"canBuy\": false}"},
    {name = "FOODDELIVERY_DATA", type = "string", default = "{\"level\": 0, \"jobs\": 0, \"canBuy\": false}"},
    {name = "WAREHOUSE_DATA", type = "string", default = "{\"level\": 0, \"jobs\": 0, \"canBuy\": false}"},
    {name = "CHAR_APPEREANCE", type = "string", default = "{}"},
    {name = "LAST_LOCATION", type = "string", default = "{\"x\": 0.0, \"y\": 0.0, \"z\": 0.0,}"},
    {name = "CHAR_VEHICLES", type = "string", default = "[]"},
}

Config.charactersPath = "./characters/" 