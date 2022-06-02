PlayState = Class{__includes = BaseState}

function PlayState:enter(params)
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.ball = params.ball

    self.ball.dx = math.random(-100, 100)
    self.ball.dy = math.random(50, 60)
end

function PlayState:update(dt)
    -- pausing/unpausing
    if self.paused then
        if love.keyboard.wasPressed('space') then
            self.paused = false
            gSounds['pause']:play()
        else
            return
        end
    elseif love.keyboard.wasPressed('space') then
            self.paused = true
            gSounds['pause']:play()
            return
    end

    self.paddle:update(dt)
    self.ball:update(dt)

    -- collision detection
    if self.ball:collides(self.paddle) then
        self.ball.y = self.paddle.y - 8
        self.ball.dy = -self.ball.dy

        -- if we hit the paddle on its left side while moving left...
        if self.ball.x < self.paddle.x + (self.paddle.width / 2) and self.paddle.dx < 0 then
            self.ball.dx = -50 + -(
                8 * (self.paddle.x + self.paddle.width / 2 - self.ball.x)
            )
        
        -- else if we hit the paddle on its right side while moving right...
        elseif self.ball.x > self.paddle.x + (self.paddle.width / 2) and self.paddle.dx > 0 then
            self.ball.dx = 50 + (
                8 * math.abs(self.paddle.x + self.paddle.width / 2 - self.ball.x)
            )
        end

        gSounds['paddle-hit']:play()
    end

    for k, brick in pairs(self.bricks) do
        if brick.inPlay and self.ball:collides(brick) then
            brick:hit()

            -- ball is moving right and is left of the brick
            if self.ball.dx > 0 and self.ball.x + 2 < brick.x then
                self.ball.dx = -self.ball.dx

            -- ball is moving left and is right of the brick
            elseif self.ball.dx < 0 and self.ball.x + 6 > brick.x + brick.width then
                self.ball.dx = -self.ball.dx

            -- no x collisions so check if ball has hit bottom edge of brick
            elseif self.ball.y < brick.y then
                self.ball.dy = -self.ball.dy

            -- last possibilty: top edge collision
            else
                self.ball.dy = -self.ball.dy

            end

            self.score = self.score + 1
            self.ball.dy = self.ball.dy * 1.02
            -- exit loop to prevent multiple bricks from colliding
            break
        end
    end

    -- ball out of bounds detection
    if self.ball.y > VIRTUAL_HEIGHT then
        self.health = self.health - 1
        gSounds['hurt']:play()

        if self.health == 0 then
            gStateMachine:change('game-over', {
                score = self.score
            })
        else
            gStateMachine:change('serve', {
                paddle = self.paddle,
                score = self.score,
                health = self.health,
                bricks = self.bricks
            })
        end
    end

    -- exiting
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function PlayState:render()

    for k, brick in pairs(self.bricks) do
        brick:render()
    end

    self.paddle:render()
    self.ball:render()

    renderScore(self.score)
    renderHealth(self.health)

    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf(
            'PAUSED',
            0,
            VIRTUAL_HEIGHT / 2 - 16,
            VIRTUAL_WIDTH,
            'center'
        )
    end
end
