push = require 'push'
Class = require 'class'
require 'Bird'

WINDOW = {
    Width = 1391,
    Height = 720,
    VirtualWidth = 556,
    VirtualHeight = 288
}

BACKGROUND_HEIGHT = 20
local BACKGROUND_LOOPING_POINT = 624.5

local background = love.graphics.newImage('assets/background.png')
local backgroundScroll = 0
local BACKGROUND_SCROLL_SPEED = 45

local ground = love.graphics.newImage('assets/ground.png')
local groundScroll = 0
local GROUND_SCROLL_SPEED = 90

local bird = Bird()


function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
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
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) 
        % BACKGROUND_LOOPING_POINT

    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) 
        % WINDOW.VirtualWidth
end



function drawBackground()
    love.graphics.draw(background, -backgroundScroll, 0)
    love.graphics.draw(ground, -groundScroll, WINDOW.VirtualHeight - BACKGROUND_HEIGHT)
end

function drawFPS()
    love.graphics.setColor(0, 255/255, 0, 255/255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end


function love.draw()
    push:apply('start')

    drawBackground()

    bird:render()

    drawFPS()

    push:apply('end')
end


function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end