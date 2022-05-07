ScoreState = Class{__includes = BaseState}

function ScoreState:enter(params)
    self.score = params.score
    self.bronzeMedal = love.graphics.newImage('resources/images/bronze_medal.png')
    self.silverMedal = love.graphics.newImage('resources/images/silver_medal.png')
    self.goldMedal = love.graphics.newImage('resources/images/gold_medal.png')
end

function ScoreState:update(dt)
    updateBackgroundElements(dt)
    -- go back to play if enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function ScoreState:render()
    -- simply render the score to the middle of the screen
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Oof! You lost!', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')

    love.graphics.printf('Press Enter to Play Again!', 0, 160, VIRTUAL_WIDTH, 'center')

    -- render medals
    if self.score > 9 then
        love.graphics.draw(self.goldMedal, VIRTUAL_WIDTH / 2 - 10, 120)
    elseif self.score > 5 then
        love.graphics.draw(self.silverMedal, VIRTUAL_WIDTH / 2 - 10, 120)
    elseif self.score > 2 then
        love.graphics.draw(self.bronzeMedal, VIRTUAL_WIDTH / 2 - 10, 120)
    end
end
