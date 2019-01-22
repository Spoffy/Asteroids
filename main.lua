local tick = require "tick"
local System = require "knife.system"
local physics_helpers = require "physics_helpers"
local entityTemplates = require "entities"


assets = {}
world = nil
entities = {}


function love.load()
  assets.ship = love.graphics.newImage("assets/images/ship_large_body.png");
  assets.obstacle = love.graphics.newImage("assets/images/ship_small_body.png");

  love.physics.setMeter(64)
  world = love.physics.newWorld(0,0,true)

  entities.ship = entityTemplates.ship(50, 50, assets.ship)
  entities.obstacle = entityTemplates.obstacle(50, 50, assets.obstacle)

  love.graphics.setBackgroundColor(0.2, 0.2, 0.2)
  love.window.setMode(650, 650, {vsync = false, msaa = 2})
end

local wrapMap = System(
  { 'physics' },
  function (p, dt)
    local windowWidth, windowHeight = love.graphics.getDimensions()
    if p.body:getX() < 0 then
      p.body:setX(windowWidth)
    elseif p.body:getX() > windowWidth then
      p.body:setX(0)
    end
    if p.body:getY() < 0 then
      p.body:setY(windowHeight)
    elseif p.body:getY() > windowHeight then
      p.body:setY(0)
    end
  end
)

local delta = 0

function love.update(dt)
  delta = dt
  world:update(dt)

  for name,entity in pairs(entities) do
    wrapMap(entity, dt)
  end

  do
    local ship = entities.ship
    local phys = ship.physics


    if love.keyboard.isDown('w') then
        phys:accelerate()
    end
    if love.keyboard.isDown('s') then
        phys:decelerate()
    end
    if love.keyboard.isDown('a') then
        phys:rotateCounterClockwise()
    end
    if love.keyboard.isDown('d') then
        phys:rotateClockwise()
    end
    if love.keyboard.isDown('d') and love.keyboard.isDown('a') or not love.keyboard.isDown('a') and not love.keyboard.isDown('d') then
        phys:stopRotation()
    end
  end

end

local drawPhysicsObjects = System(
  { 'drawable', 'physics' },
  function (d, p, dt)
    d.draw(p.body:getX(), p.body:getY(), p.body:getAngle())
  end
)

local canvas = love.graphics.newCanvas()

function love.draw()
  love.graphics.setCanvas(canvas)
  love.graphics.clear()
  for name,entity in pairs(entities) do
    drawPhysicsObjects(entity, 0)
  end
  love.graphics.print(tostring(love.timer.getFPS()), 20, 20)
  love.graphics.print(tostring(delta), 40, 40)
  love.graphics.setCanvas()
  love.graphics.draw(canvas)
end
