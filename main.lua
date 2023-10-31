push = require 'push'


WINDOW = {
    Width = 1180,
    Height = 600,
    VirtualWidth = 590,
    VirtualHeight = 300
}

BACKGROUND_HEIGHT = 41

local background = love.graphics.newImage('assets/background.jpg')
local ground = love.graphics.newImage('assets/ground.jpg')


function love.load()
    -- love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Flappy Bird')

    math.randomseed(os.time())

    -- smallFont = love.graphics.newFont('font.ttf', 10)
    -- largeFont = love.graphics.newFont('font.ttf', 25)

    
    push:setupScreen(WINDOW.VirtualWidth, WINDOW.VirtualHeight, WINDOW.Width, WINDOW.Height, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

end

function love.resize(w, h)
    push:resize(w, h)
end


function love.update(dt) 
    
end



function drawUI()
    love.graphics.draw(background, 0, 0)
    love.graphics.draw(ground, 0, WINDOW.VirtualHeight - BACKGROUND_HEIGHT)
end

function drawFPS()
    love.graphics.setColor(0, 255/255, 0, 255/255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end


function love.draw()
    push:apply('start')

    drawUI()

    drawFPS()

    push:apply('end')
end


function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end