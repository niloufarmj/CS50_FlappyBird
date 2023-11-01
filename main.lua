push = require 'push'
Class = require 'class'

require 'Bird'
require 'Pipe'
require 'StateMachine'
require 'states/BaseState'
require 'states/PlayState'
require 'states/TitleScreenState'
require 'states/ScoreState'

WINDOW = {
    Width = 1391,
    Height = 720,
    VirtualWidth = 556,
    VirtualHeight = 288
}

GROUND_HEIGHT = 20
local BACKGROUND_LOOPING_POINT = 624.5

local background = love.graphics.newImage('assets/background.png')
local backgroundScroll = 0
local BACKGROUND_SCROLL_SPEED = 45

local ground = love.graphics.newImage('assets/ground.png')
local groundScroll = 0
local GROUND_SCROLL_SPEED = 90


function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Lolli Bird')

    math.randomseed(os.time())

    smallFont = love.graphics.newFont('dpcomic.ttf', 8)
    mediumFont = love.graphics.newFont('dpcomic.ttf', 26)
    hugeFont = love.graphics.newFont('dpcomic.ttf', 56)

    push:setupScreen(WINDOW.VirtualWidth, WINDOW.VirtualHeight, WINDOW.Width, WINDOW.Height, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function () return ScoreState() end,
    }
    gStateMachine:change('title')

    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt) 

    -- move background
    updateBackground(dt)

    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
end

function updateBackground(dt)
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) 
        % BACKGROUND_LOOPING_POINT

    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) 
        % WINDOW.VirtualWidth
end

function drawBackground()
    love.graphics.draw(background, -backgroundScroll, 0)
    love.graphics.draw(ground, -groundScroll, WINDOW.VirtualHeight - GROUND_HEIGHT)
end

function drawFPS()
    love.graphics.setColor(0, 255/255, 0, 255/255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end

function love.draw()
    push:apply('start')

    drawBackground()
    gStateMachine:render()

    push:apply('end')
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
    
    if key == 'escape' then
        love.event.quit()
    end
    
end