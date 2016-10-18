-- Just enable everything with the rocket silo for now.
table.insert(data.raw["technology"]["rocket-silo"].effects, {type = "unlock-recipe", recipe = "cargo-transport-rocket-silo"})
table.insert(data.raw["technology"]["rocket-silo"].effects, {type = "unlock-recipe", recipe = "cargo-transport-rocket-part"})

table.insert(data.raw["technology"]["rocket-silo"].effects, {type = "unlock-recipe", recipe = "space-assembling-machine"})
table.insert(data.raw["technology"]["rocket-silo"].effects, {type = "unlock-recipe", recipe = "space-platform-structure"})

table.insert(data.raw["technology"]["rocket-silo"].effects, {type = "unlock-recipe", recipe = "crew-rocket-silo"})
table.insert(data.raw["technology"]["rocket-silo"].effects, {type = "unlock-recipe", recipe = "crew-rocket-part"})
table.insert(data.raw["technology"]["rocket-silo"].effects, {type = "unlock-recipe", recipe = "rocket-crew-capsule"})
