--- Sprite
-- @param image_path path to the image file (relative to love2d project root)
-- @param frame_size table with frame dimensions {width, height} or single number for both width and height
-- @param states optional table of animation states { state_name = frame_index or {fps=10, frames={1,2,3}} }
function Sprite(image_path, frame_size, states)
    local image = love.graphics.newImage(image_path)

    -- Handle frame_size as number or table
    local frame_width, frame_height
    if type(frame_size) == "number" then
        frame_width = frame_size
        frame_height = frame_size
    elseif type(frame_size) == "table" then
        frame_width = frame_size.width or frame_size[1]
        frame_height = frame_size.height or frame_size[2]
    else
        frame_width = image:getWidth()
        frame_height = image:getHeight()
    end

    -- Calculate grid dimensions
    local image_width, image_height = image:getDimensions()
    local cols = math.floor(image_width / frame_width)
    local rows = math.floor(image_height / frame_height)

    -- Pre-create all quads for the sprite sheet
    local quads = {}
    for row = 0, rows - 1 do
        for col = 0, cols - 1 do
            local index = row * cols + col + 1
            quads[index] = love.graphics.newQuad(
                col * frame_width,
                row * frame_height,
                frame_width,
                frame_height,
                image_width,
                image_height
            )
        end
    end

    local state_quads = {}
    local first_state = nil
    for name, data in pairs(states) do
        if first_state == nil then
            first_state = name
        end

        if type(data) ~= "table" then
            state_quads[name] = {duration=0, quads={quads[data]}}
        else
            local fps = data.fps
            local quads_ = {}
            for _, index in ipairs(data.frames) do
                table.insert(quads_, quads[index])
            end
            state_quads[name] = {duration=1/fps, quads=quads_}
        end
    end

    return {
        name="sprite",
        image=image,
        width=frame_width,
        height=frame_height,
        states=state_quads,
        current_state=first_state,
        current_frame=1,
        time_elapsed=0,
    }
end
