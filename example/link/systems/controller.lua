local ecs = require("rune.ecs")
local utils = require("example.vampire.utils")


Controller = {}


Controller.filter = {
    players=ecs.And{"control", "position", "speed"},
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

        -- set sprite state
        local dx = x - entity.position.x
        local dy = y - entity.position.y

        local idle = dx == 0 and dy == 0
        local degrees = (math.deg(math.atan2(dy, dx)) + 90) % 360  -- TODO: this works, but probably a better way to write. x=0,y=0 is top left of screen. 0deg should be top of screen direction.

        if entity.sprite ~= nil then
            local last_state = entity.sprite.current_state
            if idle == true and last_state == "walk_up" then
                entity.sprite.current_state = "face_up"
            elseif idle == true and last_state == "walk_down" then
                entity.sprite.current_state = "face_down"
            elseif idle == true and last_state == "walk_left" then
                entity.sprite.current_state = "face_left"
            elseif idle == true and last_state == "walk_right" then
                entity.sprite.current_state = "face_right"
            elseif idle == false and (degrees < 90 or degrees > 270) then
                entity.sprite.current_state = "walk_up"
            elseif idle == false and (degrees > 90 and degrees < 270) then
                entity.sprite.current_state = "walk_down"
            elseif idle == false and degrees == 270 then
                entity.sprite.current_state = "walk_left"
            elseif idle == false and degrees == 90 then
                entity.sprite.current_state = "walk_right"
            end
        end

        -- update new position
        entity.position.x = x
        entity.position.y = y
    end
end
