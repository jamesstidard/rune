---@diagnostic disable: duplicate-set-field
require("components.*")
require("systems.*")

local DEBUG = arg[#arg] == "vsc_debug"
if DEBUG then
    require("lldebugger").start()
end

local WIDTH = 32*16
local HEIGHT = 32*16

local ecs = require("rune.ecs")
local world = nil


function love.load()
    love.window.setMode(WIDTH, HEIGHT)

    -- local bg_color = COLOR.PURPLE
    -- love.graphics.setBackgroundColor(bg_color.red, bg_color.green, bg_color.blue)

    world = ecs.World()

    world.ctx.window = {width=WIDTH, height=HEIGHT}

    -- register systems
    world.add_system(Controller, "update")
    world.add_system(Hit, "update")
    world.add_system(Lifetimes, "update")
    world.add_system(Physics, "update")
    world.add_system(Rendering, "draw")
    world.add_system(Timing, "update")

    -- load player entity
    local player_entity = {
        Sprite(
            "assets/link.png",
            {width=24, height=32},  -- width and height of a single sprite in the sheet. this should be a multiple of the actual width and height of the entire png
            {
                face_up=1,  -- single static sprite, the 65th sprite counting from
                face_down=28,
                face_left=37,
                face_right=13,
                walk_up={fps=10, frames={5, 6, 5, 57, 58, 57}},
                walk_down={fps=10, frames={25, 82, 25, 76, 31, 76}},
                walk_left={fps=10, frames={40, 43, 40, 85, 93, 85}},
                walk_right={fps=10, frames={16, 19, 16, 67, 70, 67}},
            }
        ),
        Hitbox("circle", nil, nil, 5),
        Color(255, 255, 255, 1),
        Position(world.ctx.window.width/2, world.ctx.window.height/2),
        Speed(150),
        Control(),
        Team(1),
        HP(100),
    }
    local player_uid = world.add_entity(player_entity)

    local world_clock = {
        Duration(0)
    }
    world.add_entity(world_clock)
end


function love.update(dt)
    world:update(dt)
end


function love.draw()
    world:draw()
end
