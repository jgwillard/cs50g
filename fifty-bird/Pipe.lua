Pipe = Class{}

local PIPE_IMAGE = love.graphics.newImage('pipe.png')

function Pipe:init(y, orientation)

    -- when a Pipe is initialized it should be just off
    -- the right edge of the screen
    self.x = VIRTUAL_WIDTH
    self.y = y

    self.width = PIPE_IMAGE:getWidth()
    self.height = PIPE_IMAGE:getHeight()
    self.orientation = orientation
end

function Pipe:update(dt)
    -- noop
end

function Pipe:render()
    if self.orientation == 'bottom' then
        love.graphics.draw(PIPE_IMAGE, self.x, self.y)
    else
        love.graphics.draw(PIPE_IMAGE, self.x, self.y + self.height, 0, 1, -1)
    end
end
