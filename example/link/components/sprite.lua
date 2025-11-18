--- Sprite
-- @param image_path path to the image file (relative to love2d project root)
-- @param width optional width override (uses image width if nil)
-- @param height optional height override (uses image height if nil)
-- @param quad optional quad for sprite sheets {x, y, width, height}
function Sprite(image_path, width, height, quad)
    local image = love.graphics.newImage(image_path)

    return {
        name="sprite",
        image=image,
        width=width or image:getWidth(),
        height=height or image:getHeight(),
        quad=quad and love.graphics.newQuad(quad.x, quad.y, quad.width, quad.height, image:getDimensions()) or nil,
    }
end
