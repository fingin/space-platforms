require("control-rocket")
require("control-platform")

script.on_event(defines.events.on_built_entity, function(event)
    checkForNewSilo(event.created_entity)
    checkForSpaceOnlyBuildings(event)
end)
script.on_event(defines.events.on_robot_built_entity, function(event)
    checkForNewSilo(event.created_entity)
end)
script.on_event(defines.events.on_tick, function(event)
    rocketTick()
    platformTick()
end)

script.on_event(defines.events.on_chunk_generated, function(event)
    platformChunkEvent(event)
end)

script.on_event(defines.events.on_rocket_launched, function(event)
    onRocketLaunchFinished(event)
end)

function message(msg)
    for i, player in pairs(game.players) do
        player.print(msg)
    end
end
