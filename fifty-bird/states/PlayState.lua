PlayState = Class{__includes = BaseState}

local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

local PIPE_HEIGHT = 288
local PIPE_WIDTH = 70

local BACKGROUND_LOOPING_POINT = 413

function PlayState:init()
    self.bird = Bird()
    self.pipePairs = {}

    self.spawnTimer = 0
    self.lastY = math.random(80) + 20 - PIPE_HEIGHT 
end

function PlayState:update(dt)
    
    self.spawnTimer = self.spawnTimer + dt

    if self.spawnTimer > 2 then
        local y = math.max(
            10 - PIPE_HEIGHT,
            math.min(
                self.lastY + math.random(-20, 20),
                VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT
            )
        )
        self.lastY = y
        table.insert(self.pipePairs, PipePair(y, GROUND_SCROLL_SPEED, PIPE_HEIGHT))
        self.spawnTimer = 0
    end

    self.bird:update(dt)

    for k, pipePair in pairs(self.pipePairs) do
        pipePair:update(dt)

        for l, pipe in pairs(pipePair.pipes) do
            if self.bird:collides(pipe) then
                gStateMachine:change('title')
            end
        end
    end

    for k, pipePair in pairs(self.pipePairs) do
        -- if pipe is past left edge of screen, remove it
        if pipePair.remove then
            table.remove(pipePair, k)
        end
    end

    if self.bird.y > VIRTUAL_HEIGHT then
        gStateMachine:change('title')
    end
end

function PlayState:render()
    for k, pipePair in pairs(self.pipePairs) do
        pipePair:render()
    end

    self.bird:render()
end
