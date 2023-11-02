ScoreState = Class{__includes = BaseState}

local award = love.graphics.newImage('assets/award.png')

function ScoreState:enter(params)
    self.score = params.score
end

function ScoreState:update(dt)
    if love.keyboard.keysPressed['enter'] or love.keyboard.keysPressed['return'] then
        gStateMachine:change('countDown')
    end
end

function ScoreState:render()
    -- simply render the score to the middle of the screen
    love.graphics.setFont(hugeFont)

    if self.score < 30 then
        love.graphics.printf('Oops! You lost!', 0, 70, WINDOW.VirtualWidth, 'center')
    else
        love.graphics.printf('Congrats! You Won!', 0, 70, WINDOW.VirtualWidth, 'center')
    end

    love.graphics.setFont(mediumFont)

    if self.score <= 0 then
        love.graphics.printf('Score: ' .. tostring(self.score), 0, 130, WINDOW.VirtualWidth, 'center')
    else
        love.graphics.printf('Score: ' .. tostring(self.score), -50, 130, WINDOW.VirtualWidth, 'center')
        love.graphics.draw(award, WINDOW.VirtualWidth / 2 , 132)
        if self.score >= 10 then
            love.graphics.draw(award, WINDOW.VirtualWidth / 2 + 20 , 132)
        end
        if self.score >= 20 then
            love.graphics.draw(award, WINDOW.VirtualWidth / 2 + 40 , 132)
        end

    end

    love.graphics.printf('Press Enter to Play Again!', 0, 160, WINDOW.VirtualWidth, 'center')
end