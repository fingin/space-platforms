for i, force in pairs(game.forces) do 
    force.reset_technologies()
end
for i, force in pairs(game.forces) do 
    if force.technologies["rocket-silo"].researched then 
        --force.recipes["cargo-rocket-silo"].enabled = true
        --force.recipes["cargo-rocket-part"].enabled = true

        force.recipes["space-assembling-machine"].enabled = true
        force.recipes["space-platform-structure"].enabled = true

        force.recipes["crew-rocket-silo"].enabled = true
        force.recipes["crew-rocket-part"].enabled = true
        force.recipes["rocket-crew-capsule"].enabled = true
    end
end
