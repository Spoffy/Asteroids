local components = require "components"
local physics_helpers = require "physics_helpers"

local M = {}

function M.ship(x, y, image)
    local ship = {}

    --Drawable
    ship.drawable = components.drawable(image)
    ship.drawable.rotation = math.pi / 2
    ship.drawable.offset_x = image:getWidth() / 2
    ship.drawable.offset_y = image:getHeight() / 2

    --Physics
    ship.physics = components.physics()
    local phys = ship.physics

    phys.angularVelocity = math.pi
    phys.thrust = 600

    phys.bowPoints = physics_helpers.gimpPointsToPhysicsPoints( {18,125,24,63,54,1,85,63,90,125 }, image:getWidth(), image:getHeight())
    phys.bellyPoints = physics_helpers.gimpPointsToPhysicsPoints({0,125,114,125,109,258,0,257}, image:getWidth(), image:getHeight())
    phys.sternPoints = physics_helpers.gimpPointsToPhysicsPoints({18,258,90,259,80,339,28,339}, image:getWidth(), image:getHeight())

    phys.body = love.physics.newBody(world, x, y, "dynamic")
    phys.bow = love.physics.newPolygonShape(phys.bowPoints)
    phys.belly = love.physics.newPolygonShape(phys.bellyPoints)
    phys.stern = love.physics.newPolygonShape(phys.sternPoints)
    phys.fixtureBow = love.physics.newFixture(phys.body, phys.bow, 1)
    phys.fixtureBelly = love.physics.newFixture(phys.body, phys.belly, 1)
    phys.fixtureStern = love.physics.newFixture(phys.body, phys.stern, 1)

    phys.body:setAngularDamping(0.1)
    phys.body:setLinearDamping(0.1)

    phys.accelerate = function(self)
        local shipDirX, shipDirY = physics_helpers.angleToVec(phys.body:getAngle())
        self.body:applyForce(shipDirX * self.thrust, shipDirY * self.thrust)
    end

    phys.decelerate = function(self)
        local shipDirX, shipDirY = physics_helpers.angleToVec(phys.body:getAngle())
        self.body:applyForce(shipDirX * -self.thrust, shipDirY * -self.thrust)
    end

    phys.rotateCounterClockwise = function(self)
        self.body:setAngularVelocity(-self.angularVelocity)
    end

    phys.rotateClockwise = function(self)
        self.body:setAngularVelocity(self.angularVelocity)
    end

    return ship
end

function M.obstacle(x, y, image)
    local obs = {}

    --Drawable
    obs.drawable = components.drawable(image)
    obs.drawable.rotation = math.pi / 2
    obs.drawable.offset_x = image:getWidth() / 2
    obs.drawable.offset_y = image:getHeight() / 2

    --Physics
    obs.physics = {
        --Required
        body = love.physics.newBody(world, x, y, "dynamic")
    }

    obs.physics.shape = love.physics.newRectangleShape(image:getHeight(),image:getWidth())
    obs.physics.fixture = love.physics.newFixture(obs.physics.body, obs.physics.shape, 1)

    return obs

end

return M
