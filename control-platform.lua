
function platformTick()
    if not game.surfaces["space-platform"] then
        --Create the space-platform surface as soon as we can. This means we can ensure chunks are generated before we move any entities into space.
        local settings = {
            terrain_segmentation="none",
            water="none",
            
            autoplace_controls={},
            width=0,
            height=0,
            starting_area="none",
            peaceful_mode=true,
        }
        local autoplace_controls = {"iron-ore", "copper-ore", "stone", "coal", "crude-oil", "enemy-base"}
        for name, value in ipairs(autoplace_controls) do
            settings.autoplace_controls[name]={frequency="none",size="none",richness="none"}
        end
        game.create_surface("space-platform", settings)
        game.surfaces["space-platform"].request_to_generate_chunks({0, 0}, 3)
        game.surfaces["space-platform"].always_day = true
    end
end

function platformChunkEvent(event)
    --Only handle chunks on our space platform surface.
    if event.surface.name ~= "space-platform" then return end
    
    --Clear our the new chunk from everything. We just want empty space, and there is no way to have factorio generate an empty map.
    for i, entity in ipairs(event.surface.find_entities(event.area)) do
        if entity.type ~= "player" then
            entity.destroy()
        end
    end
    
    --Fill everything with deep space, except for the center area. Which we will fill with a bit of space platform so we have a starting area.
    local tiles = {}
    for x=event.area.left_top.x, event.area.right_bottom.x do
        for y=event.area.left_top.y, event.area.right_bottom.y do
            if x >= 10 or y >= 10 or x < -10 or y < -10 then
                table.insert(tiles, {name="deep-space", position={x, y}})
            else
                table.insert(tiles, {name="space-platform", position={x, y}})
            end
        end
    end
    event.surface.set_tiles(tiles)
end

function createPlatformEntities()
    --We assume that at this point all the center chunks for the platform surface have been loaded. (Worse case if someone loads this mod on a save that has already a rocket with satellite ready for launch)
    --Pretty safe assumption, as the cargo tracking only works if the rocket was launched when this mod was active. And the launch of a rocket should take long enough to generate these chunks.
    local surface = game.surfaces["space-platform"]
    table.insert(global.space_platform_cargo_arrivals, surface.create_entity{name="cargo-arrival", position={-2.5,-4.5}, force=game.players[1].force})
    table.insert(global.space_platform_cargo_arrivals, surface.create_entity{name="cargo-arrival", position={ 2.5,-4.5}, force=game.players[1].force})
    table.insert(global.space_platform_cargo_arrivals, surface.create_entity{name="cargo-arrival", position={-2.5,-8.5}, force=game.players[1].force})
    table.insert(global.space_platform_cargo_arrivals, surface.create_entity{name="cargo-arrival", position={ 2.5,-8.5}, force=game.players[1].force})
    
    table.insert(global.silos, {silo=surface.create_entity{name="return-rocket-silo", position={0, 5.5}, force=game.players[1].force}})
    surface.create_entity{name="solar-panel", position={-8.5, 3.5}, force=game.players[1].force}
    surface.create_entity{name="solar-panel", position={-8.5, 7.5}, force=game.players[1].force}
    surface.create_entity{name="solar-panel", position={-5.5, 3.5}, force=game.players[1].force}
    surface.create_entity{name="solar-panel", position={-5.5, 7.5}, force=game.players[1].force}
    surface.create_entity{name="solar-panel", position={ 5.5, 3.5}, force=game.players[1].force}
    surface.create_entity{name="solar-panel", position={ 5.5, 7.5}, force=game.players[1].force}
    surface.create_entity{name="solar-panel", position={ 8.5, 3.5}, force=game.players[1].force}
    surface.create_entity{name="solar-panel", position={ 8.5, 7.5}, force=game.players[1].force}
    
    surface.create_entity{name="medium-electric-pole", position={-5.5, 5.5}, force=game.players[1].force}
    surface.create_entity{name="medium-electric-pole", position={ 5.5, 5.5}, force=game.players[1].force}
end

function checkForSpaceOnlyBuildings(event)
    if event.created_entity.surface.name ~= "space-platform" then
        if event.created_entity.name == "space-assembling-machine" then
            game.players[event.player_index].character.insert({name="space-assembling-machine", count=1})
            event.created_entity.destroy()
            game.players[event.player_index].print("Cannot place space assemling machine outside of the space platform")
        elseif event.created_entity.type == "entity-ghost" and event.created_entity.ghost_name == "space-assembling-machine" then
            event.created_entity.destroy()
            game.players[event.player_index].print("Cannot place space assemling machine outside of the space platform")
        end
    end
end
