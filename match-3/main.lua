require 'src/Dependencies'

-- initialize our nearest-neighbor filter
love.graphics.setDefaultFilter('nearest', 'nearest')

-- physical screen dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- virtual resolution dimensions
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- speed at which our background texture will scroll
BACKGROUND_SCROLL_SPEED = 80

function love.load()
    
    -- window bar title
    love.window.setTitle('Match 3')

    -- seed the RNG
    math.randomseed(os.time())

    -- initialize our virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true,
        canvas = true
    })

    -- set music to loop and start
    gSounds['music']:setLooping(true)
    gSounds['music']:play()

    sprite = love.graphics.newImage('graphics/bird.png')
    MOVEMENT_TIME = 2
    SPRITE_WIDTH = sprite:getWidth()
    SPRITE_HEIGHT = sprite:getHeight()
    bird = { x = 0, y = 0 }
    Chain(
        function (go)
            Timer.tween(MOVEMENT_TIME, {
                [bird] = { x = VIRTUAL_WIDTH - SPRITE_WIDTH }
            })
            Timer.after(MOVEMENT_TIME, go)
        end,
        function (go)
            Timer.tween(2, {
                [bird] = { y = VIRTUAL_HEIGHT - SPRITE_HEIGHT }
            })
            Timer.after(MOVEMENT_TIME, go)
        end,
        function (go)
            Timer.tween(2, {
                [bird] = { x = 0 }
            })
            Timer.after(MOVEMENT_TIME, go)
        end,
        function (go)
            Timer.tween(2, {
                [bird] = { y = 0 }
            })
            Timer.after(MOVEMENT_TIME, go)
        end
    )()

    -- keep track of scrolling our background on the X axis
    backgroundX = 0

    -- initialize input table
    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    
    -- add to our table of keys pressed this frame
    love.keyboard.keysPressed[key] = true
    if key == 'escape' then
        love.event.quit()
    end
end

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function love.update(dt)
    
    -- scroll background, used across all states
    backgroundX = backgroundX - BACKGROUND_SCROLL_SPEED * dt
    
    -- if we've scrolled the entire image, reset it to 0
    if backgroundX <= -1024 + VIRTUAL_WIDTH - 4 + 51 then
        backgroundX = 0
    end

    --gStateMachine:update(dt)
    Timer.update(dt)

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()

    -- scrolling background drawn behind every state
    love.graphics.draw(gTextures['background'], backgroundX, 0)

    love.graphics.draw(sprite, bird.x, bird.y)

    --gStateMachine:render()
    push:finish()
end
