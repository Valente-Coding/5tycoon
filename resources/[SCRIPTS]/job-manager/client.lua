-- local jobs = nil
local jobs = {} -- Test Variable
local currentJob = nil
local jobDefaultData = {
    jobID = nil, 
    waypoints = {
        
    },

    jobLevels = {

    },

    npcs = {
        
    },

    works = {

    },
}

local waypointDefaultData = {
    current = nil,
    label = "",
    sprite = nil,
    color = nil,
    scale = 0.7,
    short = true,
    coords = {
        x = nil, 
        y = nil, 
        z = nil
    }, 
}

local npcDefaultData = {
    current = nil,
    name = nil, 
    model = nil, 
    coords = {
        x = nil, 
        y = nil, 
        z = nil,
        h = nil,
    }, 
    god = true,
    freeze = true,
    menuOps = {},
}

local npcMenuOptionDefaultData = {
    label = nil,
    delay = 0,
    eventName = nil,
    eventType = "client",
}

local worksDefaultData = {
    
}

function deepcopy(orig, copies)
    copies = copies or {}
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        if copies[orig] then
            copy = copies[orig]
        else
            copy = {}
            copies[orig] = copy
            for orig_key, orig_value in next, orig, nil do
                copy[deepcopy(orig_key, copies)] = deepcopy(orig_value, copies)
            end
            setmetatable(copy, deepcopy(getmetatable(orig), copies))
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function GetJobData(jobID)
    if jobs == nil then 
        return nil
    end

    for _, job in pairs(jobs) do 
        if job.jobID == jobID then 
            return job
        end
    end

    local newJob = deepcopy(jobDefaultData)

    newJob.jobID = jobID

    return newJob
end

function SaveJobsConfigs()
    TriggerServerEvent("save-load:saveData", "./jobconfigs/jobs.json", jobs, true)
end

function LoadJobsConfigs()
    for i, job in pairs(jobs) do 
        LoadJobConfig(job)
    end
end

RegisterNetEvent("save-load:loadDataResult")
AddEventHandler("save-load:loadDataResult", function(data, path)
    if path == "./jobconfigs/jobs.json" then 
        --TriggerEvent("save-load:setGlobalVariables", {{name = "HOUSES_DATA", type = "string", value = json.encode(data)}}) 
        if data == nil then 
            jobs = {}
        else
            jobs = data
        end
        LoadJobsConfigs()
    end
end)

Citizen.CreateThread(function()
    --TriggerServerEvent("save-load:saveData", "./housing/houses.json", houseSaleBlips)
    TriggerServerEvent("save-load:loadData", "./jobconfigs/jobs.json", GetPlayerServerId(PlayerId()))
end)

RegisterCommand("jobconfig", function(source, args, rawCommand)
    if #args <= 0 then 
        TriggerEvent("notification:send", {time = 5000, text = "/jobconfig [jobID]", color = "blue"})
        return
    end

    if args[1] ~= "" then 
        currentJob = deepcopy(GetJobData(args[1]))
        OpenJobConfigMenu()
    else
        TriggerEvent("notification:send", {time = 5000, text = "/jobconfig [jobID]", color = "blue"})
        return
    end

    

end, false)

function OpenJobConfigMenu()
    TriggerEvent("side-menu:resetOptions")

    TriggerEvent("side-menu:addOptions", {
        {id = "job_id", label = "Job ID:", quantity = currentJob.jobID}, 
        {id = "job_open_hp_config", label = "Waypoints Config", cb = function()
            OpenWaypointsConfigMenu()
        end},
        {id = "job_open_npcs_config", label = "Npcs Config", cb = function()
            OpenNpcsConfigMenu()
        end},
        {id = "job_open_works_config", label = "Works Config", cb = function()
            OpenWorksConfigMenu()
        end},
        {id = "job_save_current_job", label = "Save", cb = function()
            SaveJobConfig()
        end},
        {id = "job_delete_current_job", label = "Delete", cb = function()
            TriggerEvent("side-menu:resetOptions")
            
            TriggerEvent("side-menu:addOptions", {
                {id = "job_waypoint_delete_confirm", label = "Confirm", cb = function()
                    DeleteJobConfig()
                end}, 
                {id = "job_waypoint_delete_decline", label = "Back", cb = function()
                    OpenJobConfigMenu()
                end}, 
            })
        end},
        {id = "job_close_menu", label = "Close", cb = function()
            TriggerEvent("side-menu:resetOptions")
        end},
    })
end

function GetJobIndex(jobID)
    for i, job in pairs(jobs) do 
        if job.jobID == jobID then 
            return i
        end
    end

    return nil
end

function SaveJobConfig()
    local jobIndex = GetJobIndex(currentJob.jobID)

    if jobIndex == nil then 
        table.insert(jobs, deepcopy(currentJob))
    else
        jobs[jobIndex] = deepcopy(currentJob)
    end

    SaveJobsConfigs()
    TriggerEvent("notification:send", {time = 5000, text = "All changes to the job "..currentJob.jobID.." were saved.", color = "green"})
end

function LoadJobConfig(job)
    for i, wp in pairs(job.waypoints) do 
        if wp.current then 
            TriggerEvent("waypointer:remove", wp.current)
            wp.current = nil
        end

        wp.current = job.jobID.."_"..wp.label
        TriggerEvent("waypointer:add", wp.current, wp)
    end

    for i, npc in pairs(job.npcs) do 
        if npc.current then 
            DeleteEntity(npc.current)
        end

        npc.current = CreateJobNpc(npc)
    end
end

function DeleteJobConfig()
    local jobIndex = GetJobIndex(currentJob.jobID)

    if jobIndex == nil then
        TriggerEvent("notification:send", {time = 5000, text = "This job config was never saved before.", color = "yellow"})
        OpenJobConfigMenu()
    else
        TriggerEvent("notification:send", {time = 5000, text = "Job config deleted.", color = "green"})
        table.remove(jobs, jobIndex)
        TriggerEvent("side-menu:resetOptions")
    end
end


function OpenWaypointsConfigMenu()
    TriggerEvent("side-menu:resetOptions")

    local ops = {
        {id = "job_id", label = "Job ID:", quantity = currentJob.jobID}, 
        {id = "job_add_waypoint", label = "Add Waypoint", cb = function()
            TriggerEvent("side-menu:openInputBox", {title = "Waypoint Name", placeholder = "Write the name here...", cb = function(label)
                TriggerEvent("side-menu:openInputBox", {title = "Waypoint Sprite", placeholder = "Write the sprite id here...", cb = function(sprite)
                    TriggerEvent("side-menu:openInputBox", {title = "Waypoint Color", placeholder = "Write the color id here...", cb = function(color)
                        TriggerEvent("side-menu:openInputBox", {title = "Waypoint Scale", placeholder = "Write the scale here...", cb = function(scale)
                            TriggerEvent("side-menu:openInputBox", {title = "Waypoint Short Range", placeholder = "Write true or false here...", cb = function(short)
                                AddWaypointToJob(label:gsub("\n", ""), sprite:gsub("\n", ""), color:gsub("\n", ""), scale:gsub("\n", ""), short:gsub("\n", ""))
                            end})
                        end})
                    end})
                end})
            end})
        end}, 
        {id = "job_close_waypoint_menu", label = "Back", cb = function()
            OpenJobConfigMenu()
        end}, 
        {id = "job_waypoints", label = "---[Waypoints]"}, 
    }

    for i, wp in pairs(currentJob.waypoints) do  
        table.insert(ops, {id = "waypoint_"..i, label = wp.label, cb = function()
            DisplayWaypointInfo(wp, i)
        end})
    end

    TriggerEvent("side-menu:addOptions", ops)
end

function OpenNpcsConfigMenu()
    TriggerEvent("side-menu:resetOptions")

    local ops = {
        {id = "job_id", label = "Job ID:", quantity = currentJob.jobID}, 
        {id = "job_add_npc", label = "Add NPC", cb = function()
            TriggerEvent("side-menu:openInputBox", {title = "NPC Name", placeholder = "Write the name here...", cb = function(name)
                TriggerEvent("side-menu:openInputBox", {title = "NPC Model", placeholder = "Write the model here...", cb = function(model)
                    TriggerEvent("side-menu:openInputBox", {title = "NPC God Mode", placeholder = "Write true or false here...", cb = function(god)
                        TriggerEvent("side-menu:openInputBox", {title = "NPC Freeze", placeholder = "Write true or false here...", cb = function(freeze)
                            AddNpcToJob(name:gsub("\n", ""), model:gsub("\n", ""), god:gsub("\n", ""), freeze:gsub("\n", ""))
                        end})
                    end})
                end})
            end})
        end}, 
        {id = "job_close_npc_menu", label = "Back", cb = function()
            OpenJobConfigMenu()
        end}, 
        {id = "job_npcs", label = "---[NPCs]"}, 
    }

    for i, npc in pairs(currentJob.npcs) do  
        table.insert(ops, {id = "npc_"..i, label = npc.name, cb = function()
            DisplayNpcInfo(npc, i)
        end})
    end

    TriggerEvent("side-menu:addOptions", ops)
end

function OpenWorksConfigMenu()
    TriggerEvent("side-menu:resetOptions")


end

function DisplayWaypointInfo(waypoint, index)
    TriggerEvent("side-menu:resetOptions")

    print(json.encode(currentJob.waypoints))
    TriggerEvent("side-menu:addOptions", {
        {id = "job_waypoint_label", label = "Label:", quantity = waypoint.label, cb = function()
            TriggerEvent("side-menu:openInputBox", {title = "Waypoint Name", placeholder = "Write the name here...", cb = function(label)
                waypoint.label = label:gsub("\n", "")
                DisplayWaypointInfo(waypoint, index)
            end})
        end}, 
        {id = "job_waypoint_sprite", label = "Sprite:", quantity = waypoint.sprite, cb = function()
            TriggerEvent("side-menu:openInputBox", {title = "Waypoint Sprite", placeholder = "Write the sprite id here...", cb = function(sprite)
                waypoint.sprite = tonumber(sprite:gsub("\n", ""))
                DisplayWaypointInfo(waypoint, index)
            end})
        end},
        {id = "job_waypoint_color", label = "Color:", quantity = waypoint.color, cb = function()
            TriggerEvent("side-menu:openInputBox", {title = "Waypoint Color", placeholder = "Write the color id here...", cb = function(color)
                waypoint.color = tonumber(color:gsub("\n", ""))
                DisplayWaypointInfo(waypoint, index)
            end})
        end},
        {id = "job_waypoint_scale", label = "Scale:", quantity = waypoint.scale, cb = function()
            TriggerEvent("side-menu:openInputBox", {title = "Waypoint Scale", placeholder = "Write the scale here...", cb = function(scale)
                waypoint.scale = tonumber(scale:gsub("\n", ""))
                DisplayWaypointInfo(waypoint, index)
            end})
        end},
        {id = "job_waypoint_short", label = "Short Range:", quantity = waypoint.short, cb = function()
            TriggerEvent("side-menu:openInputBox", {title = "Waypoint Short Range", placeholder = "Write true or false here...", cb = function(short)
                short = short:gsub("\n", "")

                if short == "false" or short == "False" then
                    waypoint.short = false
                else
                    waypoint.short = true
                end

                DisplayWaypointInfo(waypoint, index)
            end})
        end},
        {id = "job_waypoint_coords_x", label = "X:", quantity = waypoint.coords.x, cb = function()
            TriggerEvent("side-menu:openInputBox", {title = "Waypoint Coord X", placeholder = "Write the x coordinate here...", cb = function(x)
                waypoint.coords.x = tonumber(x:gsub("\n", ""))
                DisplayWaypointInfo(waypoint, index)
            end})
        end}, 
        {id = "job_waypoint_coords_y", label = "Y:", quantity = waypoint.coords.y, cb = function()
            TriggerEvent("side-menu:openInputBox", {title = "Waypoint Coord Y", placeholder = "Write the y coordinate here...", cb = function(y)
                waypoint.coords.y = tonumber(y:gsub("\n", ""))
                DisplayWaypointInfo(waypoint, index)
            end})
        end},
        {id = "job_waypoint_coords_z", label = "Z:", quantity = waypoint.coords.z, cb = function()
            TriggerEvent("side-menu:openInputBox", {title = "Waypoint Coord Z", placeholder = "Write the z coordinate here...", cb = function(z)
                waypoint.coords.z = tonumber(z:gsub("\n", ""))
                DisplayWaypointInfo(waypoint, index)
            end})
        end}, 
        {id = "job_waypoint_go_to", label = "Go to", cb = function()
            SetEntityCoords(GetPlayerPed(-1), waypoint.coords.x, waypoint.coords.y, waypoint.coords.z, 0.0, 0.0, 0.0, false)
        end}, 
        {id = "job_waypoint_delete", label = "Delete", cb = function()
            TriggerEvent("side-menu:resetOptions")
            
            TriggerEvent("side-menu:addOptions", {
                {id = "job_waypoint_delete_confirm", label = "Confirm", cb = function()
                    TriggerEvent("waypointer:remove", currentJob.waypoints[index].current)
                    table.remove(currentJob.waypoints, index)
                    OpenWaypointsConfigMenu()
                end}, 
                {id = "job_waypoint_delete_decline", label = "Back", cb = function()
                    DisplayWaypointInfo(waypoint, index)
                end}, 
            })
        end}, 
        {id = "job_waypoint_back", label = "Back", cb = function()
            OpenWaypointsConfigMenu()
        end}, 
    })
end

function DisplayNpcInfo(npc, index)
    TriggerEvent("side-menu:resetOptions")

    TriggerEvent("side-menu:addOptions", {
        {id = "job_npc_name", label = "Name:", quantity = npc.name, cb = function()
            TriggerEvent("side-menu:openInputBox", {title = "NPC Name", placeholder = "Write the name here...", cb = function(name)
                npc.name = name:gsub("\n", "")
                DisplayNpcInfo(npc, index)
            end})
        end}, 
        {id = "job_npc_model", label = "Model:", quantity = npc.model, cb = function()
            TriggerEvent("side-menu:openInputBox", {title = "NPC Model", placeholder = "Write the model here...", cb = function(model)
                npc.model = model:gsub("\n", "")
                DisplayNpcInfo(npc, index)
            end})
        end}, 
        {id = "job_npc_god", label = "God Mode:", quantity = npc.god, cb = function()
            TriggerEvent("side-menu:openInputBox", {title = "NPC God Mode", placeholder = "Write true or false here...", cb = function(god)
                god = god:gsub("\n", "")

                if god == "false" or god == "False" then
                    npc.god = false
                else
                    npc.god = true
                end

                DisplayNpcInfo(npc, index)
            end})
        end},
        {id = "job_npc_freeze", label = "Freezed:", quantity = npc.freeze, cb = function()
            TriggerEvent("side-menu:openInputBox", {title = "NPC Freeze", placeholder = "Write true or false here...", cb = function(freeze)
                freeze = freeze:gsub("\n", "")

                if freeze == "false" or freeze == "False" then
                    npc.freeze = false
                else
                    npc.freeze = true
                end

                DisplayNpcInfo(npc, index)
            end})
        end},
        {id = "job_npc_coords_x", label = "X:", quantity = npc.coords.x, cb = function()
            TriggerEvent("side-menu:openInputBox", {title = "NPC Coord X", placeholder = "Write the x coordinate here...", cb = function(x)
                npc.coords.x = tonumber(x:gsub("\n", ""))
                DisplayNpcInfo(npc, index)
            end})
        end}, 
        {id = "job_npc_coords_y", label = "Y:", quantity = npc.coords.y, cb = function()
            TriggerEvent("side-menu:openInputBox", {title = "NPC Coord Y", placeholder = "Write the y coordinate here...", cb = function(y)
                npc.coords.y = tonumber(y:gsub("\n", ""))
                DisplayNpcInfo(npc, index)
            end})
        end},
        {id = "job_npc_coords_z", label = "Z:", quantity = npc.coords.z, cb = function()
            TriggerEvent("side-menu:openInputBox", {title = "NPC Coord Z", placeholder = "Write the z coordinate here...", cb = function(z)
                npc.coords.z = tonumber(z:gsub("\n", ""))
                DisplayNpcInfo(npc, index)
            end})
        end}, 
        {id = "job_npc_coords_h", label = "H:", quantity = npc.coords.h, cb = function()
            TriggerEvent("side-menu:openInputBox", {title = "NPC Heading", placeholder = "Write the heading here...", cb = function(h)
                npc.coords.h = tonumber(h:gsub("\n", ""))
                DisplayNpcInfo(npc, index)
            end})
        end}, 
        {id = "job_npc_event_list", label = "Options List", cb = function()
            OpenNpcEventsMenu(npc.menuOps, npc, index)
        end}, 
        {id = "job_npc_go_to", label = "Go to", cb = function()
            SetEntityCoords(GetPlayerPed(-1), npc.coords.x, npc.coords.y, npc.coords.z, 0.0, 0.0, 0.0, false)
        end}, 
        {id = "job_npc_delete", label = "Delete", cb = function()
            TriggerEvent("side-menu:resetOptions")
            
            TriggerEvent("side-menu:addOptions", {
                {id = "job_npc_delete_confirm", label = "Confirm", cb = function()
                    if npc.current then 
                        DeleteEntity(npc.current)
                    end

                    table.remove(currentJob.npcs, index)
                    OpenNpcsConfigMenu()
                end}, 
                {id = "job_npc_delete_decline", label = "Back", cb = function()
                    DisplayNpcInfo(npc, index)
                end}, 
            })
        end}, 
        {id = "job_npc_label", label = "Back", cb = function()
            OpenNpcsConfigMenu()
        end}, 
    })
end

function OpenNpcEventsMenu(options, npc, index)
    TriggerEvent("side-menu:resetOptions")

    local ops = {
        {id = "npc_menu_add_option", label = "Add New Option", cb = function()
            TriggerEvent("side-menu:openInputBox", {title = "Option Label", placeholder = "Write the label here...", cb = function(label)
                TriggerEvent("side-menu:openInputBox", {title = "Option Event Name", placeholder = "Write the event name here...", cb = function(eventName)
                    TriggerEvent("side-menu:openInputBox", {title = "Option Event Type", placeholder = "Write client or server here...", cb = function(eventType)
                        AddNpcMenuOption(options, label:gsub("\n", ""), eventName:gsub("\n", ""), eventType:gsub("\n", ""))
                    end})
                end})
            end})
        end}, 
        {id = "npc_menu_close", label = "Back", cb = function()
            DisplayNpcInfo(npc, index)
        end}, 
        {id = "npc_menu_options", label = "---[Options]"}, 
    }

    for i, op in pairs(options) do  
        table.insert(ops, {id = "npc_option_"..i, label = op.label, cb = function()
            DisplayNpcMenuOption(ops, npc, op, i)
        end})
    end

    TriggerEvent("side-menu:addOptions", ops)
end

function DisplayNpcMenuOption(options, npc, op, index)
    TriggerEvent("side-menu:resetOptions")

    TriggerEvent("side-menu:addOptions", {
        {id = "job_npc_menu_option_label", label = "Label:", quantity = op.label, cb = function()
            TriggerEvent("side-menu:openInputBox", {title = "Option Label", placeholder = "Write the label here...", cb = function(label)
                op.label = label:gsub("\n", "")
                DisplayNpcMenuOption(options, npc, op, index)
            end})
        end},
        {id = "job_npc_menu_option_delay", label = "Delay:", quantity = op.delay, cb = function()
            TriggerEvent("side-menu:openInputBox", {title = "Option Delay", placeholder = "Write the delay here...", cb = function(delay)
                op.delay = tonumber(delay:gsub("\n", ""))
                DisplayNpcMenuOption(options, npc, op, index)
            end})
        end},
        {id = "job_npc_menu_option_event_name", label = "Event Name:", quantity = op.eventName, cb = function()
            TriggerEvent("side-menu:openInputBox", {title = "Option Event Name", placeholder = "Write the event name here...", cb = function(eventName)
                op.eventName = eventName:gsub("\n", "")
                DisplayNpcMenuOption(options, npc, op, index)
            end})
        end},
        {id = "job_npc_menu_option_event_type", label = "Event Type:", quantity = op.eventType, cb = function()
            TriggerEvent("side-menu:openInputBox", {title = "Option Event Type", placeholder = "Write client or server here...", cb = function(eventType)
                op.eventType = eventType:gsub("\n", "")
                DisplayNpcMenuOption(options, npc, op, index)
            end})
        end},
        {id = "job_npc_menu_option_close", label = "Back", cb = function()
            OpenNpcEventsMenu(options, npc, index)
        end}, 
    })
end

function AddNpcMenuOption(options, label, eventName, eventType)
    local newOption = deepcopy(npcMenuOptionDefaultData)
    newOption.label = label
    newOption.eventName = eventName

    if eventType == "server" or eventType == "Server" then
        newOption.eventType = "server"
    else
        newOption.eventType = "client"
    end

    table.insert(options, deepcopy(newOption))

    OpenNpcEventsMenu(options)
end

function AddWaypointToJob(label, sprite, color, scale, short)
    if currentJob == nil then return end

    local newWaypoint = deepcopy(waypointDefaultData)

    newWaypoint.label = label
    newWaypoint.sprite = tonumber(sprite)
    newWaypoint.color = tonumber(color)
    newWaypoint.scale = tonumber(scale)
    
    if short == "false" or short == "False" then
        newWaypoint.short = false
    else
        newWaypoint.short = true
    end

    local pedCoords = GetEntityCoords(GetPlayerPed(-1))
    newWaypoint.coords.x = pedCoords.x 
    newWaypoint.coords.y = pedCoords.y 
    newWaypoint.coords.z = pedCoords.z - 1.0


    table.insert(currentJob.waypoints, deepcopy(newWaypoint))

    OpenWaypointsConfigMenu()
end

function AddNpcToJob(name, model, god, freeze)
    if currentJob == nil then return end

    local newNpc = deepcopy(npcDefaultData)

    newNpc.name = name
    newNpc.model = model

    if god == "false" or god == "False" then
        newNpc.god = false
    else
        newNpc.god = true
    end

    if freeze == "false" or freeze == "False" then
        newNpc.freeze = false
    else
        newNpc.freeze = true
    end

    local pedCoords = GetEntityCoords(GetPlayerPed(-1))
    newNpc.coords.x = pedCoords.x 
    newNpc.coords.y = pedCoords.y 
    newNpc.coords.z = pedCoords.z - 1.0
    newNpc.coords.h = GetEntityHeading(GetPlayerPed(-1))


    table.insert(currentJob.npcs, deepcopy(newNpc))

    OpenNpcsConfigMenu()
end



function CreateJobNpc(npcData)
    local model = npcData.model
    RequestModel(model)
    while not HasModelLoaded(model) do 
        Citizen.Wait(1)
    end

    local newNpc = CreatePed(26, GetHashKey(model), npcData.coords.x, npcData.coords.y, npcData.coords.z, npcData.coords.h, false, true)

    if npcData.god == true then 
        SetEntityInvincible(newNpc, true)
    end

    TaskSetBlockingOfNonTemporaryEvents(newNpc, true)

    return newNpc
end


Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(100)
        for i, job in pairs(jobs) do 
            for j, npc in pairs(job.npcs) do 
                if npc.current then 
                    if npc.freeze == true then 
                        FreezeEntityPosition(npc.current, true)
                    end
                end
            end
        end
    end
end)
