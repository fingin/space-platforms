data:extend(
{
  {
    type = "item",
    name = "rocket-crew-capsule",
    icon = "__base__/graphics/icons/rocket-part.png",
    flags = {"goes-to-main-inventory"},
    subgroup = "intermediate-product",
    order = "p[satellite]",
    stack_size = 1
  },
  {
    type = "recipe",
    name = "rocket-crew-capsule",
    energy_required = 3,
    enabled = false,
    category = "crafting",
    ingredients =
    {
      {"low-density-structure", 40},
      {"solar-panel", 5},
      {"accumulator", 5},
      {"radar", 5},
      {"processing-unit", 40},
      {"rocket-fuel", 25}
    },
    result= "rocket-crew-capsule"
  },
  
  {
    type = "logistic-container",
    name = "cargo-arrival",
    icon = "__base__/graphics/icons/beacon.png",
    flags = {},
    max_health = 5000,
    corpse = "big-remnants",
    dying_explosion = "medium-explosion",
    collision_box = {{-1.2, -1.2}, {1.2, 1.2}},
    selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
    inventory_size = 80,
    logistic_mode = "requester",
    picture =
    {
      filename = "__base__/graphics/entity/beacon/beacon-base.png",
      width = 116,
      height = 93,
      shift = { 0.34375, 0.046875}
    },
    resistances =
    {
      { type = "physical", percent = 100},
      { type = "fire", percent = 100},
      { type = "acid", percent = 100},
      { type = "poison", percent = 100},
      { type = "explosion", percent = 100},
      { type = "laser", percent = 100},
    },
  },
}
)
