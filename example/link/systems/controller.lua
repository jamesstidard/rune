local ecs = require("rune.ecs")
local utils = require("example.vampire.utils")


Controller = {}


Controller.filter = {
    players=ecs.And{"control", "position", "speed", ecs.Optional("direction"), ecs.Optional("walking")},
    collidables=ecs.And{"hitbox", "collidable"}
}


function Controller.run(world, entities, dt)
    for euid, entity in pairs(entities.players) do
        local speed = entity.speed.pixels

        local x = entity.position.x
        local y = entity.position.y

        if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
            y = y - (speed * dt)
        end
        if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
            x = x - (speed * dt)
        end
        if love.keyboard.isDown("s") or love.keyboard.isDown("down") then
            y = y + (speed * dt)
        end
        if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
            x = x + (speed * dt)
        end

        local moved = utils.deepcopy(entity)
        moved.position.x = x
        moved.position.y = y
        for _, collidable in pairs(entities.collidables) do
            if utils.is_colliding(world, moved, collidable) then
                -- oh, we've hit something... lets call it quits
                return
            end
        end

        -- set sprite direction
        local dx = x - entity.position.x
        local dy = y - entity.position.y

        if entity.direction ~= nil then
            entity.direction.degrees = math.deg(math.atan2(dy, dx))
        end

        -- for tracking
        if dx ~= 0 or dy ~= 0 then
            world.add_component(euid, Walking())
        elseif entity.walking ~= nil then
            world.remove_component(euid, entity.walking)
        end

        -- update new position
        entity.position.x = x
        entity.position.y = y
    end
end
