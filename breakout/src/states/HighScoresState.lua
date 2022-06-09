HighScoresState = Class{__includes = BaseState}

function HighScoresState:enter(params)
    self.highScores = params.highScores
end

function HighScoresState:update(dt)
    if love.keyboard.wasPressed('escape') then
        gSounds['wall-hit']:play()

        gStateMachine:change('start', {
            highScores = self.highScores
        })
    end
end

function HighScoresState:render()
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('High Scores', 0, 20, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['medium'])

    for i = 1, 10 do
        local name = self.highScores[i].name or '---'
        local score = self.highScores[i].score or '---'

        love.graphics.printf(
            tostring(i) .. '.',
            VIRTUAL_WIDTH / 4,
            60 + i * 13,
            50,
            'left'
        )

        love.graphics.printf(
            name,
            VIRTUAL_WIDTH / 4 + 38,
            60 + i * 13,
            50,
            'right'
        )

        love.graphics.printf(
            score,
            VIRTUAL_WIDTH / 2,
            60 + i * 13,
            100,
            'right'
        )
    end
end
