Pipe = Class{}

local PIPE_IMAGE = love.graphics.newImage('pipe.png')

function Pipe:init(pipeScrollSpeed)

    self.pipeScrollSpeed = pipeScrollSpeed
    -- when a Pipe is initialized it should be just off
    -- the right edge of the screen
    self.x = VIRTUAL_WIDTH

    self.y = math.random(VIRTUAL_HEIGHT / 4, VIRTUAL_HEIGHT - 20)

    self.width = PIPE_IMAGE:getWidth()
end

function Pipe:update(dt)
    self.x = self.x - self.pipeScrollSpeed * dt
end

function Pipe:render()
    love.graphics.draw(PIPE_IMAGE, self.x, self.y)
end
