push = require 'push'
Class = require 'class'
require 'Paddle'
require 'Ball'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

function love.load()

    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle('Pong')

    math.randomseed(os.time())

    smallFont = love.graphics.newFont('font.ttf', 8)
    largeFont = love.graphics.newFont('font.ttf', 16)
    scoreFont = love.graphics.newFont('font.ttf', 32)

    sounds = {
        ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static')
    }

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    is2playergame = false

    player1score = 0
    player2score = 0

    servingPlayer = 1

    player1 = Paddle(10, 30, 5, 20)
    player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 50, 5, 20)

    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    gamestate = 'start'
end

-- called on resize; pass width and height through to push
function love.resize(w, h)
    push:resize(w, h)
end

-- called once per frame with delta in seconds since last frame
function love.update(dt)

    if gamestate == 'serve' then
        ball.dy = math.random(-50, 50)

        if servingPlayer == 1 then
            ball.dx = math.random(140, 200)
        else
            ball.dx = -math.random(140, 200)
        end

    elseif gamestate == 'play' then
        -- ball-paddle collision detection
        if ball:collides(player1) then
            ball.dx = -ball.dx * 1.03
            ball.x = player1.x + 5

            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end

            sounds['paddle_hit']:play()
        end

        if ball:collides(player2) then
            ball.dx = -ball.dx * 1.03
            ball.x = player2.x - ball.width

            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end

            sounds['paddle_hit']:play()
        end

        -- ball-wall collision detection
        if ball.y <= 0 then
            ball.y = 0
            ball.dy = -ball.dy

            sounds['wall_hit']:play()
        end

        if ball.y >= VIRTUAL_HEIGHT - ball.width then
            ball.y = VIRTUAL_HEIGHT - ball.width
            ball.dy = -ball.dy

            sounds['wall_hit']:play()
        end

        -- goal collision detection
        if ball.x <= 0 then
            servingPlayer = 1
            player2score = player2score + 1
            sounds['score']:play()

            if player2score == 10 then
                winningPlayer = 2
                gamestate = 'done'
            else
                gamestate = 'serve'
                ball:reset()
            end
        end

        if ball.x >= VIRTUAL_WIDTH + ball.width then
            servingPlayer = 2
            player1score = player1score + 1
            sounds['score']:play()

            if player1score == 10 then
                winningPlayer = 1
                gamestate = 'done'
            else
                gamestate = 'serve'
                ball:reset()
            end
        end
    end

    -- paddle movement
    if love.keyboard.isDown('w') then
        player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        player1.dy = PADDLE_SPEED
    else
        player1.dy = 0
    end

    if is2playergame then
        if love.keyboard.isDown('up') then
            player2.dy = -PADDLE_SPEED
        elseif love.keyboard.isDown('down') then
            player2.dy = PADDLE_SPEED
        else
            player2.dy = 0
        end
    else
        player2.y = ball.y - 8
    end

    if gamestate == 'play' then
        ball:update(dt)
    end

    player1:update(dt)
    player2:update(dt)
end


-- called once per frame with key state
function love.keypressed(key)

    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if gamestate == 'start' or gamestate == 'serve' then
            gamestate = 'play'
        elseif gamestate == 'done' then
            gamestate = 'serve'
            ball:reset()
            player1score = 0
            player2score = 0
        end
    end
end

-- called after `update` and used to draw to the screen
function love.draw()

    push:apply('start')

    love.graphics.clear(40/255, 45/255, 52/255, 255/255)

    renderObjects()

    displayState()
    displayScore()
    -- special function to demo FPS in love2d
    displayFPS()

    push:apply('end')
end

function renderObjects()
    player1:render()
    player2:render()
    ball:render()
end

function displayState()
    love.graphics.setFont(smallFont)
    if gamestate == 'start' then
        love.graphics.printf('Welcome to Pong', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to Begin', 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gamestate == 'serve' then
        love.graphics.printf('Player ' .. tostring(servingPlayer) .. ' to serve!',
            0, 20, VIRTUAL_WIDTH, 'center')
    elseif gamestate == 'play' then
        -- noop
    elseif gamestate == 'done' then
        love.graphics.setFont(largeFont)
        love.graphics.printf('Player ' .. tostring(winningPlayer) .. ' wins!',
            0, 10, VIRTUAL_WIDTH, 'center')
    end
end

function displayScore()
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)
end

function displayFPS()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255/255, 0, 255/255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end
