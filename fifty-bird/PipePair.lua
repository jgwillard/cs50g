PipePair = Class{}

local GAP_HEIGHT = 90

function PipePair:init(y, pipeScrollSpeed, pipeHeight)
    self.x = VIRTUAL_WIDTH
    self.y = y

    self.pipeScrollSpeed = pipeScrollSpeed

    self.pipes = {
        ['upper'] = Pipe(self.y, 'top'),
        ['lower'] = Pipe(self.y + GAP_HEIGHT + pipeHeight, 'bottom')
    }

    self.remove = false
end

function PipePair:update(dt)
    if self.x < -self.pipes['upper'].width then
        self.remove = true
    else
        self.x = self.x - self.pipeScrollSpeed * dt
        self.pipes['upper'].x = self.x
        self.pipes['lower'].x = self.x
    end
end

function PipePair:render()
    for k, pipe in pairs(self.pipes) do
        pipe:render()
    end
end
