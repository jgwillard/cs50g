ServeState = Class{__includes = BaseState}

function ServeState:enter(params)
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.score = params.score
    self.health = params.health

    self.ball = Ball()
    self.ball.y = self.paddle.y - 8
    self.ball.skin = math.random(7)
end

function ServeState:update(dt)
    self.paddle:update(dt)
    self.ball.x = self.paddle.x + self.paddle.width / 2 - 4

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('play', {
            ball = self.ball,
            paddle = self.paddle,
            health = self.health,
            score = self.score,
            bricks = self.bricks
        })
    end
end

function ServeState:render()
    self.paddle:render()
    self.ball:render()

    for k, brick in pairs(self.bricks) do
        brick:render()
    end

    renderScore(self.score)
    renderHealth(self.health)

    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf(
        'Press Enter to Serve!',
        0,
        VIRTUAL_HEIGHT / 2,
        VIRTUAL_WIDTH,
        'center'
    )
end