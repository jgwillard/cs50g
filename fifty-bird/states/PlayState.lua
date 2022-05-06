PlayState = Class{__includes = BaseState}

local PIPE_HEIGHT = 288

local BACKGROUND_LOOPING_POINT = 413

function PlayState:init()
    self.bird = Bird()
    self.pipePairs = {}
    self.spawnTimer = 0
    self.score = 0
    self.lastY = math.random(80) + 20 - PIPE_HEIGHT 
end

function PlayState:enter(params)
    if params then
        self.bird = params.bird
        self.pipePairs = params.pipePairs
        self.spawnTimer = params.spawnTimer
        self.score = params.score
        self.lastY = params.lastY
    end
end

function PlayState:update(dt)
    
    self.spawnTimer = self.spawnTimer + dt

    updateBackgroundElements(dt)

    -- add a pair of pipes every second and a half
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

    -- increment score
    for k, pipePair in pairs(self.pipePairs) do
        if not pipePair.scored then
            if pipePair.x + pipePair.pipes['lower'].width < self.bird.x then
                self.score = self.score + 1
                pipePair.scored = true
                sounds['score']:play()
            end
        end
    end

    -- if pipe is past left edge of screen, remove it
    for k, pipePair in pairs(self.pipePairs) do
        if pipePair.remove then
            table.remove(self.pipePairs, k)
        end
    end

    self.bird:update(dt)

    -- collision detection with pipes
    for k, pipePair in pairs(self.pipePairs) do
        pipePair:update(dt)

        for l, pipe in pairs(pipePair.pipes) do
            if self.bird:collides(pipe) then
                sounds['explosion']:play()
                sounds['hurt']:play()

                gStateMachine:change('score', {
                    score = self.score
                })
            end
        end
    end

    -- collision detection with ground
    if self.bird.y > VIRTUAL_HEIGHT then
        sounds['explosion']:play()
        sounds['hurt']:play()

        gStateMachine:change('score', {
            score = self.score
        })
    end

    -- enter pause state
    if love.keyboard.wasPressed('p') then
        gStateMachine:change('pause', {
            bird = self.bird,
            pipePairs = self.pipePairs,
            spawnTimer = self.spawnTimer,
            score = self.score,
            lastY = self.lastY,
        })
    end
end

-- global
function renderPlayStateElements(elements)
    for k, pipePair in pairs(elements.pipePairs) do
        pipePair:render()
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(elements.score), 8, 8)

    elements.bird:render()
end

function PlayState:render()
    renderPlayStateElements(self)
end
