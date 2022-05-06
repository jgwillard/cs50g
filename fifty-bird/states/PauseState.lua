PauseState = Class{__includes = BaseState}

function PauseState:enter(params)
    self.params = params
end

function PauseState:update(dt)
    -- go back to play if 'p' is pressed
    if love.keyboard.wasPressed('p') then
        gStateMachine:change('play', self.params)
    end
end

function PauseState:render()
    PlayState:renderPlayStateElements(
        self.params.pipePairs,
        self.params.score,
        self.params.bird
    )

    love.graphics.setFont(flappyFont)
    love.graphics.printf('Paused', 0, 64, VIRTUAL_WIDTH, 'center')
end
