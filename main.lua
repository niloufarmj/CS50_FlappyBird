push = require 'push'
Class = require 'class'
require 'Bird'
require 'Pipe'

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

local PIPE_DISTANCE_SECONDS = 2

local bird = Bird()

local pipes = {}
local spawnTimer = 0

local GAP_HEIGHT = 90

local lastY = -PIPE_HEIGHT + math.random(80) + 20


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

    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end


function love.update(dt) 
    -- move background
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) 
        % BACKGROUND_LOOPING_POINT

    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) 
        % WINDOW.VirtualWidth

    handlePipesUpdate(dt)

    -- bird jump
    bird:update(dt)
    
    love.keyboard.keysPressed = {}
end

function handlePipesUpdate(dt) 
    spawnTimer = spawnTimer + dt

    if spawnTimer > PIPE_DISTANCE_SECONDS then
        local y = math.max(-PIPE_HEIGHT + 10, math.min(lastY + math.random(-20, 20), WINDOW.VirtualHeight - 90 - PIPE_HEIGHT))
        lastY = y

        top_color = math.random(0, 1) == 0 and 'blue' or 'pink'
        bottom_color = top_color == 'blue' and 'pink' or 'blue'

        table.insert(pipes, Pipe('top', y, top_color))
        table.insert(pipes, Pipe('bottom', y + PIPE_HEIGHT + GAP_HEIGHT, bottom_color))
        spawnTimer = 0
    end
    
    -- move pipes (like background)
    for k, pipe in pairs(pipes) do
        pipe:update(dt)

        if pipe.x < -(PIPE_WIDTH + 10)  then
            table.remove(pipes, k)
        end
    end
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

    for k, pipe in pairs(pipes) do
        -- love.graphics.print('pipe' , 50, 50)
        pipe:render()
    end

    drawFPS()

    push:apply('end')
end


function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
    
    if key == 'escape' then
        love.event.quit()
    end
    
end