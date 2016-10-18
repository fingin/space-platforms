--[[ Due to the amount of prototypes and amount of data these prototypes have, instead of copy&paste coding all the prototypes for the different silos we have, we use a creation function that copies the original silo --]]
function createRocketSilo(prefix, scale)
    item_rocket_part = copyPrototype(prefix, data.raw["item"]["rocket-part"])
    recipe_rocket_part = copyPrototype(prefix, data.raw["recipe"]["rocket-part"])
    item_rocket_silo = copyPrototype(prefix, data.raw["item"]["rocket-silo"])
    recipe_rocket_silo = copyPrototype(prefix, data.raw["recipe"]["rocket-silo"])
    rocket_silo = copyPrototype(prefix, data.raw["rocket-silo"]["rocket-silo"])
    rocket_silo_rocket = copyPrototype(prefix, data.raw["rocket-silo-rocket"]["rocket-silo-rocket"])
    
    recipe_rocket_part.result = prefix .. recipe_rocket_part.result
    recipe_rocket_silo.result = prefix .. recipe_rocket_silo.result
    
    item_rocket_silo.place_result = prefix .. item_rocket_silo.place_result
    rocket_silo.fixed_recipe = prefix .. rocket_silo.fixed_recipe
    rocket_silo.minable.result = prefix .. rocket_silo.minable.result
    rocket_silo.rocket_entity = prefix .. rocket_silo.rocket_entity
    
    applyScaling(scale, rocket_silo)
    applyScaling(scale, rocket_silo_rocket)
    
    data:extend({
        item_rocket_part,
        recipe_rocket_part,
        item_rocket_silo,
        recipe_rocket_silo,
        rocket_silo,
        rocket_silo_rocket,
    })
end
function copyPrototype(prefix, prototype)
    result = table.deepcopy(prototype)
    result.name = prefix .. result.name
    return result
end
function applyScaling(scale, data)
    if data["collision_box"] then
        data.collision_box[1][1] = data.collision_box[1][1] * scale
        data.collision_box[1][2] = data.collision_box[1][2] * scale
        data.collision_box[2][1] = data.collision_box[2][1] * scale
        data.collision_box[2][2] = data.collision_box[2][2] * scale
    end
    if data["selection_box"] then
        data.selection_box[1][1] = data.selection_box[1][1] * scale
        data.selection_box[1][2] = data.selection_box[1][2] * scale
        data.selection_box[2][1] = data.selection_box[2][1] * scale
        data.selection_box[2][2] = data.selection_box[2][2] * scale
    end
    if data["rocket_visible_distance_from_center"] then
        data["rocket_visible_distance_from_center"] = data["rocket_visible_distance_from_center"] * scale
    end
    if data["base_light"] then
        for key, light in pairs(data["base_light"]) do
            if light["picture"] then
                applySpriteScaling(scale, light["picture"])
            end
            applySpriteScaling(scale, light)
        end
    end
    for key, value in pairs(data) do
        if string.sub(key, #key - 6) == "_sprite" then
            applySpriteScaling(scale, value)
        end
        if string.sub(key, #key - 9) == "_animation" then
            applySpriteScaling(scale, value)
        end
        if string.sub(key, #key - 6) == "_offset" then
            value[1] = value[1] * scale
            value[2] = value[2] * scale
        end
        if string.sub(key, #key - 8) == "_distance" then
            data[key] = data[key] * scale
        end
        if key == "red_lights_front_sprites" or key == "red_lights_back_sprites" then
            for idx, light in pairs(value["layers"]) do
                applySpriteScaling(scale, light)
            end
        end
    end
end
function applySpriteScaling(scale, data)
    if data["scale"] then
        data["scale"] = data["scale"] * scale
    else
        data["scale"] = scale
    end
    if data["shift"] then
        data["shift"][1] = data["shift"][1] * scale
        data["shift"][2] = data["shift"][2] * scale
    end
end

-- Create the cargo rocket silo.
createRocketSilo("cargo-transport-", 0.5)
data.raw["recipe"]["cargo-transport-rocket-part"].ingredients = { {"low-density-structure", 1}, {"rocket-fuel", 1}, {"rocket-control-unit", 1} }
data.raw["recipe"]["cargo-transport-rocket-part"].energy_required = 1.0
data.raw["recipe"]["cargo-transport-rocket-silo"].ingredients = { {"steel-plate", 100}, {"concrete", 100}, {"pipe", 10}, {"processing-unit", 20}, {"electric-engine-unit", 20} }
data.raw["rocket-silo"]["cargo-transport-rocket-silo"].rocket_parts_required = 30
data.raw["rocket-silo"]["cargo-transport-rocket-silo"].energy_usage = "50kW"
data.raw["rocket-silo"]["cargo-transport-rocket-silo"].idle_energy_usage = "2KW"
data.raw["rocket-silo"]["cargo-transport-rocket-silo"].lamp_energy_usage = "2KW"
data.raw["rocket-silo"]["cargo-transport-rocket-silo"].active_energy_usage = "800KW"
data.raw["rocket-silo-rocket"]["cargo-transport-rocket-silo-rocket"].inventory_size = 3

-- Special silo for the return rocket from the space platform.
createRocketSilo("return-", 0.7)
data.raw["rocket-silo"]["return-rocket-silo"].minable = nil
data.raw["rocket-silo"]["return-rocket-silo"].energy_usage = "25kW"
data.raw["rocket-silo"]["return-rocket-silo"].idle_energy_usage = "1KW"
data.raw["rocket-silo"]["return-rocket-silo"].lamp_energy_usage = "1KW"
data.raw["rocket-silo"]["return-rocket-silo"].active_energy_usage = "399KW"
data.raw["rocket-silo"]["return-rocket-silo"].resistances = 
{
    { type = "physical", percent = 100},
    { type = "fire", percent = 100},
    { type = "acid", percent = 100},
    { type = "poison", percent = 100},
    { type = "explosion", percent = 100},
    { type = "laser", percent = 100},
}
data.raw["rocket-silo"]["return-rocket-silo"].rocket_parts_required = 1
data.raw["recipe"]["return-rocket-part"].ingredients = {}
data.raw["recipe"]["return-rocket-part"].energy_required = 1.0

--Special rocket for crew launches, to make player transport cheaper
createRocketSilo("crew-", 0.7)
data.raw["rocket-silo"]["crew-rocket-silo"].rocket_parts_required = 30
