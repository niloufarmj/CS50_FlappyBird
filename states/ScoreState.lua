ScoreState = Class{__includes = BaseState}


function ScoreState:enter(params)
    self.score = params.score
end

function ScoreState:update(dt)
    if love.keyboard.keysPressed['enter'] or love.keyboard.keysPressed['return'] then
        gStateMachine:change('play')
    end
end

function ScoreState:render()
    -- simply render the score to the middle of the screen
    love.graphics.setFont(hugeFont)
    love.graphics.printf('Oops! You lost!', 0, 70, WINDOW.VirtualWidth, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 130, WINDOW.VirtualWidth, 'center')

    love.graphics.printf('Press Enter to Play Again!', 0, 160, WINDOW.VirtualWidth, 'center')
end