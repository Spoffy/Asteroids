--
-- Created by IntelliJ IDEA.
-- User: spoffy
-- Date: 21/01/19
-- Time: 19:54
-- To change this template use File | Settings | File Templates.
--
local M = {}

function M.angleToVec(angle)
  local y = math.sin(angle)
  local x = math.cos(angle)
  return x,y
end

function M.gimpPointsToPhysicsPoints(points, imageWidth, imageHeight)
  local output = {}
  local isX = true;
  local cache = nil;
  for i,point in ipairs(points) do
    if isX then
      cache = point
    else
      --Reorder points, change origin
      local x, y = cache, point
      table.insert(output, -y + imageHeight / 2 )
      table.insert(output, x - imageWidth / 2)
    end
    isX = not isX
  end
  return output
end

return M