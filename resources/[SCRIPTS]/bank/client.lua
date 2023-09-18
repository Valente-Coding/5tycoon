local _atms = {
    vector3(-3026.5, 70.531, 12.902),
    vector3(147.6095, -1035.7756, 29.3431),
    vector3(145.9927, -1035.1062, 29.3449),
    vector3(-1053.639, -2843.17, 27.709),
    vector3(-386.733, 6045.953, 31.501),
    vector3(-284.037, 6224.385, 31.187),
    vector3(-284.037, 6224.385, 31.187),
    vector3(-132.999, 6366.491, 31.475),
    vector3(-97.3082, 6455.4678, 31.4674),
    vector3(-95.5620, 6457.1401, 31.4609),
    vector3(155.4300, 6641.991, 31.784),
    vector3(174.6720, 6637.218, 31.784),
    vector3(1703.138, 6426.783, 32.730),
    vector3(1735.114, 6411.035, 35.164),
    vector3(1702.842, 4933.593, 42.051),
    vector3(1967.333, 3744.293, 32.272),
    vector3(1821.917, 3683.483, 34.244),
    vector3(540.0420, 2671.007, 42.177),
    vector3(2564.399, 2585.100, 38.016),
    vector3(2558.683, 349.6010, 108.050),
    vector3(2558.051, 389.4817, 108.660),
    vector3(1077.692, -775.796, 58.218),
    vector3(1139.018, -469.886, 66.789),
    vector3(1168.975, -457.241, 66.641),
    vector3(1153.884, -326.540, 69.245),
    vector3(381.2827, 323.2518, 103.270),
    vector3(236.5962, 219.7064, 106.2868),
    vector3(237.0156, 218.7564, 106.2868),
    vector3(237.4423, 217.8364, 106.2868),
    vector3(237.8817, 216.8805, 106.2868),
    vector3(238.3387, 215.9742, 106.2868),
    vector3(265.0043, 212.1717, 106.780),
    vector3(285.2029, 143.5690, 104.970),
    vector3(157.7698, 233.5450, 106.450),
    vector3(-164.568, 233.5066, 94.919),
    vector3(-1827.04, 785.5159, 138.020),
    vector3(-1409.39, -99.2603, 52.473),
    vector3(-1205.35, -325.579, 37.870),
    vector3(-1215.64, -332.231, 37.881),
    vector3(-2072.41, -316.959, 13.345),
    vector3(-2975.72, 379.7737, 14.992),
    vector3(-2956.8140, 487.6459, 15.4639),
    vector3(-2958.9673, 487.7429, 15.4639),
    vector3(-2955.70, 488.7218, 15.486),
    vector3(-3044.22, 595.2429, 7.595),
    vector3(-3144.13, 1127.415, 20.868),
    vector3(-3241.10, 996.6881, 12.500),
    vector3(-3241.11, 1009.152, 12.877),
    vector3(-1305.40, -706.240, 25.352),
    vector3(-538.225, -854.423, 29.234),
    vector3(-711.156, -818.958, 23.768),
    vector3(-717.614, -915.880, 19.268),
    vector3(-526.566, -1222.90, 18.434),
    vector3(-256.831, -719.646, 33.444),
    vector3(-203.548, -861.588, 30.205),
    vector3(112.4102, -776.162, 31.427),
    vector3(112.9290, -818.710, 31.386),
    vector3(119.9000, -883.826, 31.191),
    vector3(-846.304, -340.402, 38.687),
    vector3(-1204.9976, -326.3217, 37.8396),
    vector3(-1205.7758, -324.7910, 37.8596),
    vector3(-1216.27, -331.461, 37.773),
    vector3(-56.1935, -1752.53, 29.452),
    vector3(-261.692, -2012.64, 30.121),
    vector3(-273.001, -2025.60, 30.197),
    vector3(24.589, -946.056, 29.357),
    vector3(-254.112, -692.483, 33.616),
    vector3(-1570.197, -546.651, 34.955),
    vector3(-1415.909, -211.825, 46.500),
    vector3(-1430.112, -211.014, 46.500),
    vector3(33.232, -1347.849, 29.497),
    vector3(129.85, -1296.25, 29.27),
    vector3(287.645, -1282.646, 29.659),
    vector3(289.012, -1256.545, 29.440),
    vector3(295.839, -895.640, 29.217),
    vector3(1686.753, 4815.809, 42.008),
    vector3(-302.408, -829.945, 32.417),
    vector3(5.134, -919.949, 29.557),
    vector3(527.26, -160.76, 57.09),

    vector3(-867.19, -186.99, 37.84),
    vector3(-821.62, -1081.88, 11.13),
    vector3(-1315.32, -835.96, 16.96),
    vector3(-660.71, -854.06, 24.48),
    vector3(-1109.73, -1690.81, 4.37),
    vector3(-1091.5, 2708.66, 18.95),
    vector3(1171.98, 2702.55, 38.18),
    vector3(2683.09, 3286.53, 55.24),
    vector3(89.61, 2.37, 68.31),
    vector3(-30.3, -723.76, 44.23),
    vector3(-28.07, -724.61, 44.23),
    vector3(-613.24, -704.84, 31.24),
    vector3(-618.84, -707.9, 30.5),
    vector3(-1289.23, -226.77, 42.45),
    vector3(-1285.6, -224.28, 42.45),
    vector3(-1286.24, -213.39, 42.45),
    vector3(-1282.54, -210.45, 42.45),
    vector3(472.34, -1001.67, 30.69),
    vector3(468.19, -990.62, 26.27),
    vector3(-587.07, -141.99, 47.2),
    vector3(187.48, -899.82, 30.71),
    vector3(929.903, 29.302, 71.834),
    vector3(903.576, -152.59, 74.147),
    vector3(-218.768, -1320.504, 30.89),
}

local _banks = {
    vector3(149.9911, -1040.7634, 29.3741),
    vector3(148.4813, -1040.3076, 29.3778),
    vector3(314.1897, -279.1682, 54.1708),
    vector3(312.7511, -278.6469, 54.1745),
    vector3(241.4233, 225.3538, 106.2868),
    vector3(243.1891, 224.8077, 106.2868),
    vector3(246.6766, 223.6010, 106.2868),
    vector3(248.4177, 222.9412, 106.2867),
    vector3(251.7702, 221.7201, 106.2866),
    vector3(253.5439, 221.0961, 106.2866),
    vector3(-350.9206, -49.9460, 49.0426),
    vector3(-352.3679, -49.4674, 49.0462),
    vector3(-1212.5894, -330.7893, 37.7870),
    vector3(-1213.9246, -331.4323, 37.7907),
    vector3(-2962.5640, 483.0103, 15.7031),
    vector3(-2962.5857, 481.4398, 15.7068),
    vector3(1175.0177, 2706.8267, 38.0941),
    vector3(1176.5057, 2706.8799, 38.0977),
    vector3(-110.9127, 6468.1045, 31.6267),
    vector3(-111.9847, 6469.1978, 31.6267),
    vector3(-113.0533, 6470.2881, 31.6267),
}

local _blipsCoords = {
    vector3(150.266, -1040.203, 29.374),
    vector3(-1212.980, -330.841, 37.787),
    vector3(-2962.582, 482.627, 15.703),
    vector3(-112.202, 6469.295, 31.626),
    vector3(314.187, -278.621, 54.170),
    vector3(-351.534, -49.529, 49.042),
    vector3(241.727, 220.706, 106.286),
    vector3(1175.0643310547, 2706.6435546875, 38.094036102295)
}

local _blips = {}


Citizen.CreateThread(function()
    for _, blipCoord in pairs(_blipsCoords) do
        local blip = AddBlipForCoord(blipCoord.x, blipCoord.y, blipCoord.z)
        SetBlipSprite(blip, 207)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.7)
        SetBlipColour(blip, 2)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Bank")
        EndTextCommandSetBlipName(blip)

        table.insert(_blips, blip)
    end
end)

Citizen.CreateThread(function() 
    local currentAtmState = false
    local lastAtmState = false

    local currentBankState = false
    local lastBankState = false
    while true do 
        Citizen.Wait(1)
        local ped = GetPlayerPed(-1)
        local coords = GetEntityCoords(ped)

        -- ATM Menu
        currentAtmState = false
        for _, atm in pairs(_atms) do 
            if #(atm - coords) < 0.5 then 
                currentAtmState = true
            end
        end

        if currentAtmState ~= lastAtmState then
            lastAtmState = currentAtmState

            if currentBankState == false then 
                if currentAtmState then 
                    TriggerEvent("side-menu:addOptions", {
                        {id = "atm_balance", label = "Balance:", quantity = GetExternalKvpInt("save-load", "BANK_BALANCE")},
                        {id = "atm_withdraw", label = "Withdraw", cb = 
                            function() 
                                TriggerEvent("side-menu:openInputBox", {
                                    title = "WITHDRAW", 
                                    cb = 
                                        function(result) 
                                            TriggerEvent("bank:withdraw", result) 
                                        end
                                }) 
                            end
                        },
                    })
                elseif not currentAtmState then
                    TriggerEvent("side-menu:removeOptions", {
                        {id = "atm_balance"},
                        {id = "atm_withdraw"},
                    })
                end
            end
        end
        ---------------------------

        -- BANK Menu
        currentBankState = false
        for _, bank in pairs(_banks) do 
            if #(bank - coords) < 0.5 then 
                currentBankState = true
            end
        end

        if currentBankState ~= lastBankState then
            lastBankState = currentBankState

            if currentAtmState == false then 
                if currentBankState then 
                    TriggerEvent("side-menu:addOptions", {
                        {id = "bank_balance", label = "Balance:", quantity = GetExternalKvpInt("save-load", "BANK_BALANCE")},
                        {id = "bank_deposit", label = "Deposit", cb = 
                            function() 
                                TriggerEvent("side-menu:openInputBox", {
                                    title = "DEPOSIT", 
                                    cb = 
                                        function(result) 
                                            TriggerEvent("bank:deposit", result)
                                            TriggerEvent("notification:center", {time = 5000, text = "You've deposited $"..result})
                                        end
                                }) 
                            end
                        },
                        {id = "bank_withdraw", label = "Withdraw", cb = 
                            function() 
                                TriggerEvent("side-menu:openInputBox", {
                                    title = "WITHDRAW", 
                                    cb = 
                                        function(result) 
                                            TriggerEvent("bank:withdraw", result) 
                                            TriggerEvent("notification:center", {time = 5000, text = "You've withdrawn $"..result})
                                        end
                                }) 
                            end
                        },
                    })
                elseif not currentBankState then
                    TriggerEvent("side-menu:removeOptions", {
                        {id = "bank_balance"},
                        {id = "bank_deposit"},
                        {id = "bank_withdraw"},
                    })
                end
            end
        end
        ---------------------------
    end
end)

RegisterNetEvent("bank:deposit")
RegisterNetEvent("bank:withdraw")

function DepositMoney(amount)
    local bankMoney = GetExternalKvpInt("save-load", "BANK_BALANCE")
    local cashMoney = GetExternalKvpInt("save-load", "CASH_BALANCE")

    local value = tonumber(amount)

    if type(value) ~= "number" then
        return
    end

    if cashMoney >= value then 
        UpdateMoney((bankMoney + value), (cashMoney - value)) 
    end
end

function WithdrawMoney(amount)
    local bankMoney = GetExternalKvpInt("save-load", "BANK_BALANCE")
    local cashMoney = GetExternalKvpInt("save-load", "CASH_BALANCE")

    local value = tonumber(amount)

    if type(value) ~= "number" then
        return
    end

    if bankMoney >= value then 
        UpdateMoney((bankMoney - value), (cashMoney + value)) 
    end
end

function UpdateMoney(bank, cash) 
    TriggerEvent("side-menu:updateOptions", {{id = "bank_balance", label = "Balance:", quantity = bank}, {id = "CASH_BALANCE", label = "Cash:", quantity = cash}}) 
    
    TriggerEvent("save-load:setGlobalVariables", {{name = "BANK_BALANCE", type = "int", value = bank}, {name = "CASH_BALANCE", type = "int", value = cash}}) 
end

AddEventHandler("bank:deposit", DepositMoney)
AddEventHandler("bank:withdraw", WithdrawMoney)


RegisterNetEvent("bank:changeBank")
RegisterNetEvent("bank:changeCash")

function ChangeBank(amount, cb)
    local bankMoney = GetExternalKvpInt("save-load", "BANK_BALANCE")
    local cashMoney = GetExternalKvpInt("save-load", "CASH_BALANCE")

    local value = tonumber(amount)

    if type(value) ~= "number" then
        return
    end

    if bankMoney + value >= 0 then 
        UpdateMoney((bankMoney + value), cashMoney) 

        if value < 0 then 
            if cb then 
                cb(true)
            end
        end
    else
        if cb then 
            cb(false)
        end
    end
end

function ChangeCash(amount, cb)
    local bankMoney = GetExternalKvpInt("save-load", "BANK_BALANCE")
    local cashMoney = GetExternalKvpInt("save-load", "CASH_BALANCE")

    local value = tonumber(amount)

    if type(value) ~= "number" then
        return
    end

    if cashMoney + value >= 0 then 
        UpdateMoney(bankMoney, (cashMoney + value)) 

        if value < 0 then 
            if cb then 
                cb(true)
            end
        end
    else
        if cb then 
            cb(false)
        end
    end
end

AddEventHandler("bank:changeBank", ChangeBank)
AddEventHandler("bank:changeCash", ChangeCash)

Citizen.CreateThread(function() 
    while true do 
        Citizen.Wait(600000)
        local bankMoney = GetExternalKvpInt("save-load", "BANK_BALANCE")

        ChangeBank(math.floor(bankMoney * 0.02))
    end
end)