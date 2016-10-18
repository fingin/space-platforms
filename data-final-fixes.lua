
-- Add a "floor-layer" condition to each placeable tile item. This prevents you from using landfill on space tiles.
-- Done as an agressive modifier on everything to prevent other mods from adding items that can be placed as space platforms.
for item, data in pairs(data.raw["item"]) do
    if data["place_as_tile"] ~= nil and data["place_as_tile"].result ~= "space-platform" then
        table.insert(data.place_as_tile.condition, "floor-layer")
    end
end
