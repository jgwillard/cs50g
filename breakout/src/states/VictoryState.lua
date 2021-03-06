VictoryState = Class{__includes = BaseState}

function VictoryState:enter(params)
    self.level = params.level
    self.ball = params.ball
    self.paddle = params.paddle
    self.health = params.health
    self.score = params.score
    self.highScores = params.highScores

    self.ball.y = self.paddle.y - 8
end

function VictoryState:update(dt)
    self.paddle:update(dt)
    self.ball.x = self.paddle.x + self.paddle.width / 2 - 4

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('serve', {
            level = self.level + 1,
            bricks = LevelMaker.createMap(self.level + 1),
            paddle = self.paddle,
            health = self.health,
            score = self.score,
            highScores = self.highScores
        })
    end
end

function VictoryState:render()
    self.paddle:render()
    self.ball:render()

    renderHealth(self.health)
    renderScore(self.score)

    love.graphics.setFont(gFonts['large'])
    love.graphics.printf(
        'Level ' .. tostring(self.level) .. ' complete!',
        0,
        VIRTUAL_HEIGHT / 4,
        VIRTUAL_WIDTH,
        'center'
    )
end
