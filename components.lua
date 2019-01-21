--[[
-- Contains template definitions for each of the components
-- This is equivalent to a file of interfaces/class definitions
 ]]

local M = {}

function  M.physics()
    return {
        body =  nil,
        draw_colliders = false
    }
end

function M.drawable(asset)
    local c = {}
    c.asset = asset
    c.rotation = 0
    c.scale_x = 1
    c.scale_y = 1
    c.offset_x = 0
    c.offset_y = 0
    c.draw = function(x, y, rotation)
        rotation = rotation or 0
        love.graphics.draw(c.asset, x, y, rotation + c.rotation, c.scale_x, c.scale_y, c.offset_x, c.offset_y)
    end
    return c
end

return M
