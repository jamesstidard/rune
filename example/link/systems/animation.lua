local ecs = require("rune.ecs")
local utils = require("example.vampire.utils")


Animation = {}


Animation.filter = ecs.And {
    "sprite",
}


function Animation.run(world, entities, dt)
    for _, entity in pairs(entities) do
        local sprite = entity.sprite

        local state_data = sprite.states[sprite.current_state]
        local frame_duration = state_data.duration
        local quads = state_data.quads

        if frame_duration == 0 then
            sprite.current_frame = 1
        else
            -- probably a more elegant way to do this...
            local delta = sprite.time_elapsed + dt
            -- increase frames by time passed but maybe the state has
            local incremented = math.floor(delta / frame_duration)
            -- lua is 1-index tables. modulus doesn't play nice here...
            sprite.current_frame = ((sprite.current_frame + incremented - 1) % #quads) + 1
            -- wrap time_elapsed back to 0, just in-case its possible to integer overflow... probably not
            sprite.time_elapsed = delta - (incremented * frame_duration)
        end
    end
end
