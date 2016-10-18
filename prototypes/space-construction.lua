data:extend({

{
    type = "recipe-category",
    name = "space-crafting"
},

{
    type = "item",
    name = "space-assembling-machine",
    icon = "__space-platform__/graphics/assembling-machine/icon.png",
    flags = {"goes-to-quickbar"},
    subgroup = "production-machine",
    order = "e[assembling-machine-2]",
    place_result = "space-assembling-machine",
    stack_size = 50
},
{
    type = "recipe",
    name = "space-assembling-machine",
    enabled = false,
    ingredients =
    {
      {"assembling-machine-2", 2},
      {"advanced-circuit", 10},
      {"processing-unit", 5}
    },
    result = "space-assembling-machine",
    requester_paste_multiplier = 4
},
{
    type = "assembling-machine",
    name = "space-assembling-machine",
    icon = "__space-platform__/graphics/assembling-machine/icon.png",
    flags = {"placeable-neutral", "placeable-player", "player-creation"},
    minable = {hardness = 0.2, mining_time = 0.5, result = "space-assembling-machine"},
    max_health = 250,
    corpse = "big-remnants",
    dying_explosion = "medium-explosion",
    resistances =
    {
      {
        type = "fire",
        percent = 70
      }
    },
    fluid_boxes =
    {
      {
        production_type = "input",
        pipe_picture = assembler2pipepictures(),
        pipe_covers = pipecoverspictures(),
        base_area = 10,
        base_level = -1,
        pipe_connections = {{ type="input", position = {0, -2} }}
      },
      {
        production_type = "output",
        pipe_picture = assembler2pipepictures(),
        pipe_covers = pipecoverspictures(),
        base_area = 10,
        base_level = 1,
        pipe_connections = {{ type="output", position = {0, 2} }}
      },
      off_when_no_fluid_recipe = true
    },
    collision_box = {{-1.2, -1.2}, {1.2, 1.2}},
    selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
    fast_replaceable_group = "assembling-machine",
    animation =
    {
      filename = "__space-platform__/graphics/assembling-machine/assembling-machine.png",
      priority = "high",
      width = 113,
      height = 99,
      frame_count = 32,
      line_length = 8,
      shift = {0.4, -0.06}
    },
    open_sound = { filename = "__base__/sound/machine-open.ogg", volume = 0.85 },
    close_sound = { filename = "__base__/sound/machine-close.ogg", volume = 0.75 },
    vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
    working_sound =
    {
      sound = {
        {
          filename = "__base__/sound/assembling-machine-t2-1.ogg",
          volume = 0.8
        },
        {
          filename = "__base__/sound/assembling-machine-t2-2.ogg",
          volume = 0.8
        },
      },
      idle_sound = { filename = "__base__/sound/idle1.ogg", volume = 0.6 },
      apparent_volume = 1.5,
    },
    crafting_categories = {"space-crafting"},
    crafting_speed = 0.75,
    energy_source =
    {
      type = "electric",
      usage_priority = "secondary-input",
      emissions = 0.04 / 2.5
    },
    energy_usage = "150kW",
    ingredient_count = 6,
    module_specification =
    {
      module_slots = 2
    },
    allowed_effects = {"consumption", "speed", "productivity", "pollution"}
},

{
    type = "item",
    name = "space-platform-structure",
    icon = "__base__/graphics/icons/rocket-structure.png",
    flags = {"goes-to-main-inventory"},
    subgroup = "terrain",
    order = "c[space-platform]",
    stack_size = 100,
    place_as_tile =
    {
        result = "space-platform",
        condition_size = 1,
        condition = { "ground-tile" } --Note, this does not prevent to use this to fill water. However, you would be silly to do so.
    }
},
{
    type = "recipe",
    name = "space-platform-structure",
    energy_required = 5,
    enabled = false,
    category = "space-crafting",
    ingredients =
    {
      {"steel-plate", 2},
      {"copper-plate", 1},
      {"plastic-bar", 1}
    },
    result_count = 4,
    result = "space-platform-structure"
},

})