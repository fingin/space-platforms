data:extend(
{
{
    type = "tile",
    name = "deep-space",
    collision_mask =
    {
      "water-tile", --marking as "water-tile" so "stones" and "concrete" can not be placed on it.
      "floor-layer",--marking as "floor-layer" so "landfill" can not be placed on it, (landfill is modified by the modify script to add this condition)
      "item-layer",
      "resource-layer",
      "player-layer",
      "doodad-layer"
    },
    layer = 40,
    variants =
    {
      main =
        {
          {
            picture = "__space-platform__/graphics/terrain/space1.png",
            count = 16,
            size = 1
          },
          {
            picture = "__space-platform__/graphics/terrain/space2.png",
            count = 4,
            size = 2,
            probability = 0.39,
          },
          {
            picture = "__space-platform__/graphics/terrain/space4.png",
            count = 4,
            size = 4,
            probability = 1,
          },
        },
      inner_corner =
      {
        picture = "__base__/graphics/terrain/out-of-map-inner-corner.png",
        count = 0
      },
      outer_corner =
      {
        picture = "__base__/graphics/terrain/out-of-map-outer-corner.png",
        count = 0
      },
      side =
      {
        picture = "__base__/graphics/terrain/out-of-map-side.png",
        count = 0
      }
    },
    allowed_neighbors = { "space-platform" },
    ageing=0,
    map_color={r=0.0, g=0.0, b=0.0}
  },

  {
    type = "tile",
    name = "space-platform",
    needs_correction = false,
    collision_mask = {"ground-tile"},
    walking_speed_modifier = 1.3,
    layer = 60,
    variants =
    {
      main =
      {
        {
          picture = "__base__/graphics/terrain/stone-path/stone-path-1.png",
          count = 16,
          size = 1
        },
        {
          picture = "__base__/graphics/terrain/stone-path/stone-path-2.png",
          count = 4,
          size = 2,
          probability = 0.39,
        },
        {
          picture = "__base__/graphics/terrain/stone-path/stone-path-4.png",
          count = 4,
          size = 4,
          probability = 1,
        },
      },
      inner_corner =
      {
        picture = "__base__/graphics/terrain/stone-path/stone-path-inner-corner.png",
        count = 8
      },
      outer_corner =
      {
        picture = "__base__/graphics/terrain/stone-path/stone-path-outer-corner.png",
        count = 1
      },
      side =
      {
        picture = "__base__/graphics/terrain/stone-path/stone-path-side.png",
        count = 10
      },
      u_transition =
      {
        picture = "__base__/graphics/terrain/stone-path/stone-path-u.png",
        count = 10
      },
      o_transition =
      {
        picture = "__base__/graphics/terrain/stone-path/stone-path-o.png",
        count = 10
      }
    },
    walking_sound =
    {
      {
        filename = "__base__/sound/walking/concrete-01.ogg",
        volume = 1.2
      },
      {
        filename = "__base__/sound/walking/concrete-02.ogg",
        volume = 1.2
      },
      {
        filename = "__base__/sound/walking/concrete-03.ogg",
        volume = 1.2
      },
      {
        filename = "__base__/sound/walking/concrete-04.ogg",
        volume = 1.2
      }
    },
    map_color={r=50, g=50, b=50},
    ageing=0,
    vehicle_friction_modifier = stone_path_vehicle_speed_modifier
  },
})
