TitleScreenState = Class{__includes = BaseState}

function TitleScreenState:update(dt)
    if love.keyboard.keysPressed['enter'] or love.keyboard.keysPressed['return'] then
        gStateMachine:change('play')
    end
end

function TitleScreenState:render()
    love.graphics.setFont(hugeFont)
    love.graphics.printf('Lolli Bird', 0, 70, WINDOW.VirtualWidth, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Press Enter', 0, 130, WINDOW.VirtualWidth, 'center')
end