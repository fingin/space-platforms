function checkForNewSilo(entity)
    if entity.type == "rocket-silo" then
        table.insert(global.silos, {silo=entity})
    end
end

function isItemStackFull(item)
    if item == nil then return false end
    if not item.valid then return false end 
    if not item.valid_for_read then return false end 
    return item.count == item.prototype.stack_size
end

function rocketTick()
    if not global.silos then
        global.silos = {}
        global.rockets = {}
        global.space_platform_cargo_arrivals = {}
        for surface_name, surface in pairs(game.surfaces) do
            for i, silo in ipairs(surface.find_entities_filtered{type="rocket-silo"}) do
                table.insert(global.silos, {silo=silo})
            end
        end
    end
    
    for idx, data in ipairs(global.silos) do
        if not data.silo.valid then
            table.remove(global.silos, idx)
        else
            local silo_inv = data.silo.get_inventory(defines.inventory.rocket_silo_rocket)
            if silo_inv == nil then
                if data.has_rocket then
                    for i, rocket in ipairs(data.silo.surface.find_entities_filtered{area={{data.silo.position.x-2,data.silo.position.y-2},{data.silo.position.x+2,data.silo.position.y+2}}, type="rocket-silo-rocket"}) do
                        onRocketLaunch(data.silo, rocket)
                    end
                    data.has_rocket = nil
                end
            else
                data.has_rocket = true
            end

            if shouldAutoLaunchRocket(data.silo) then
                data.silo.launch_rocket()
            end
        end
    end
    
    for idx, data in ipairs(global.rockets) do
        if not data.rocket.valid then
            table.remove(global.rockets, idx)
            for i, player in ipairs(data.players) do
                player.active = true
                if player.surface.name == "nauvis" then
                    player.player.teleport({0, 0}, "space-platform")
                elseif player.surface.name == "space-platform" then
                    player.player.teleport({0, 0}, "nauvis")
                end
            end
        else
            for i, player in ipairs(data.players) do
                player.teleport(data.rocket.position)
            end
        end
    end
end

function shouldAutoLaunchRocket(silo)
    -- Auto launch cargo rockets when they are filled with materials.
    if silo.name ~= "cargo-transport-rocket-silo" then return false end
    
    -- If we don't have inventory, we don't have a finished rocket. So no launch.
    local inv = silo.get_inventory(defines.inventory.rocket_silo_rocket)
    if inv == nil then return false end

    -- If a stack is not filled, we do not launch yet.
    for n=1,#inv do
        if not isItemStackFull(inv[n]) then
            return false
        end
    end
    
    --Calculate the amount of stuff we are requesting right now
    local total_request = {}
    for n, chest in ipairs(global.space_platform_cargo_arrivals) do
        local chest_request = {}
        --First see how much stuff we are requesting for this chest.
        for idx=1,chest.request_slot_count do
            local request_slot = chest.get_request_slot(idx)
            if request_slot ~= nil then
                if chest_request[request_slot.name] == nil then chest_request[request_slot.name] = 0 end
                chest_request[request_slot.name] = chest_request[request_slot.name] + request_slot.count
            end
        end
        --Then, substract what we have, and add this to our totals.
        for name, count in pairs(chest_request) do
            count = count - chest.get_item_count(name)
            if count > 0 then
                if total_request[name] == nil then total_request[name] = 0 end
                total_request[name] = total_request[name] + count
            end
        end
    end
    
    --Substract the amounts that are currently already flying in by rockets.
    for n, data in ipairs(global.rockets) do
        for name, count in pairs(data.cargo) do
            if total_request[name] then
                total_request[name] = total_request[name] - count
                if total_request[name] <= 0 then total_request[name] = nil end
            end
        end
    end
    
    --total_request is now the amount of stuff we are still missing. Check if our current cargo satisfies this need.
    for n=1,#inv do
        if total_request[inv[n].name] == nil then
            --Something in this rocket is not requested
            return false
        end
        if total_request[inv[n].name] < inv.get_item_count(inv[n].name) then
            --We have more items then are needed right now. So we do not launch.
            return false
        end
    end
    return true
end


function onRocketLaunch(silo, rocket)
    local data = {rocket=rocket, players={}, cargo={}}
    table.insert(global.rockets, data)
    
    local inv = rocket.get_inventory(1) -- inventory in the rocket seems to be inventory index 1.
    --Store the actual cargo in a table, as we might override this into a satellite to prevent the default scenario script from complaining.
    data.cargo = inv.get_contents();
    
    if silo.name == "rocket-silo" or silo.name == "crew-rocket-silo" or silo.name == "return-rocket-silo" then
        if rocket.get_item_count("rocket-crew-capsule") > 0 or silo.name == "return-rocket-silo" then
            if global.platform_in_orbit then
                for i, player in ipairs(silo.surface.find_entities_filtered{area={{silo.position.x-20,silo.position.y-20},{silo.position.x+20,silo.position.y+20}}, type="player"}) do
                    table.insert(data.players, player)
                    player.active = false
                end
            else
                message("Tried to launch a crew capsule without having launched a satellite before")
            end
            
            --Change the rocket inventory to a satellite, so the default scenario script does not complain that we launched a rocket without a satellite.
            --We have stored the actual cargo at this point, so we can recover this data when we need it at the on_rocket_launched event.
            inv.clear()
            inv.insert({name="satellite", count=1})
        end
    elseif silo.name == "cargo-transport-rocket-silo" then
        --Change the rocket inventory to a satellite, so the default scenario script does not complain that we launched a rocket without a satellite.
        --We have stored the actual cargo at this point, so we can recover this data when we need it at the on_rocket_launched event.
        inv.clear()
        inv.insert({name="satellite", count=1})
    end
end

function onRocketLaunchFinished(event)
    if event.rocket.get_item_count("satellite") > 0 then
        --Undo the default scenario handling of the satellite launch.
        game.set_game_state{game_finished=false, player_won=false, can_continue=true}
        for index, player in pairs(event.rocket.force.players) do
            if player.gui.left["rocket_score"] ~= nil then
                player.gui.left["rocket_score"].destroy()
            end
        end
        for _, player in pairs(game.players) do
            frame = player.gui.left["space-progress-frame"]
            if frame then
                frame.destroy()
            end
        end
    end

    --We need to find our rocket data. As references to objects in factorio are tables, and we get a new table in the event compared to the previous one we used, we need to search for the rocket in our whole table.
    --The rocket data contains the actual cargo, as we replaced the cargo in the rocket with a satellite to prevent the default scenario control file from showing messages.
    local rocket_data = nil
    for idx, data in ipairs(global.rockets) do
        if data.rocket == event.rocket then
            rocket_data = data
        end
    end

    if rocket_data ~= nil then
        if rocket_data.cargo["satellite"] ~= nil then
            if event.rocket.name == "cargo-transport-rocket-silo-rocket" or event.rocket.name == "crew-rocket-silo-rocket" then
                message("Satellite launch failed. The rocket failed to reach orbit, use a larger rocket.")
                return
            elseif event.rocket.name == "rocket-silo-rocket" then
                if not global.platform_in_orbit then
                    message("Satellite launch succesful, you can now launch a crew capsule to transfer yourself to orbit.")
                    global.platform_in_orbit = true
                    createPlatformEntities()
                else
                    message("Launching a second sattelite does not do anything.")
                end
            end
        end
        
        if event.rocket.name == "cargo-transport-rocket-silo-rocket" then
            --First, dump our cargo in chests that require it.
            for n, chest in ipairs(global.space_platform_cargo_arrivals) do
                local chest_request = {}
                local inv = chest.get_inventory(defines.inventory.chest)
                for idx=1,chest.request_slot_count do
                    local request_slot = chest.get_request_slot(idx)
                    if request_slot ~= nil then
                        if chest_request[request_slot.name] == nil then chest_request[request_slot.name] = 0 end
                        chest_request[request_slot.name] = chest_request[request_slot.name] + request_slot.count
                    end
                end
                for name, count in pairs(chest_request) do
                    count = count - chest.get_item_count(name)
                    if count > 0 and rocket_data.cargo[name] then
                        local insert_amount = inv.insert({name=name, count=rocket_data.cargo[name]})
                        rocket_data.cargo[name] = rocket_data.cargo[name] - insert_amount
                        if rocket_data.cargo[name] == 0 then
                            rocket_data.cargo[name] = nil
                        end
                    end
                end
            end
            
            --Whatever cargo we have left, try to dump in our chests.
            for n, chest in ipairs(global.space_platform_cargo_arrivals) do
                local inv = chest.get_inventory(defines.inventory.chest)
                for name, count in pairs(rocket_data.cargo) do
                    local insert_amount = inv.insert({name=name, count=count})
                    rocket_data.cargo[name] = rocket_data.cargo[name] - insert_amount
                    if rocket_data.cargo[name] == 0 then
                        rocket_data.cargo[name] = nil
                    end
                end
            end
            
            --We still have stuff left at this point, then it is lost, as there was not enough space to store it.
            for name, count in pairs(rocket_data.cargo) do
                message("Failed to deliver:" .. count .. "x " .. name)
            end
        end
    end
end
