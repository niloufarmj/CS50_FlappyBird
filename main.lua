push = require 'push'
Class = require 'class'

require 'Bird'
require 'Pipe'
require 'StateMachine'
require 'states/BaseState'
require 'states/PlayState'
require 'states/TitleScreenState'
require 'states/ScoreState'
require 'states/CountDownState'

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

local paused = false
local paused_image = love.graphics.newImage('assets/pause.png')

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Lolli Bird')

    math.randomseed(os.time())

    smallFont = love.graphics.newFont('assets/dpcomic.ttf', 8)
    mediumFont = love.graphics.newFont('assets/dpcomic.ttf', 26)
    hugeFont = love.graphics.newFont('assets/dpcomic.ttf', 56)

    sounds = {
        ['jump'] = love.audio.newSource('sounds/jump.wav', 'static'),
        ['explosion'] = love.audio.newSource('sounds/explosion.wav', 'static'),
        ['hurt'] = love.audio.newSource('sounds/hurt.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['pause'] = love.audio.newSource('sounds/pause.mp3', 'static'),
        ['music'] = love.audio.newSource('sounds/music.wav', 'static')
    }

    push:setupScreen(WINDOW.VirtualWidth, WINDOW.VirtualHeight, WINDOW.Width, WINDOW.Height, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function () return ScoreState() end,
        ['countDown'] = function () return CountdownState() end,
    }
    gStateMachine:change('title')

    sounds['music']:setLooping(true)
    sounds['music']:play()

    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt) 

    if not paused then
        -- move background
        updateBackground(dt)

        gStateMachine:update(dt)
    end

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

    if paused then
        love.graphics.draw(paused_image, WINDOW.VirtualWidth / 2 - 65, WINDOW.VirtualHeight / 2 - 65)
    end

    push:apply('end')
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true

    if key == 'p' and gStateMachine.currentName == 'play' then
        paused = not paused
        sounds['pause']:play()

        if paused then
            -- Pause the background music
            backgroundMusicPosition = sounds['music']:tell()
            sounds['music']:pause()
        else
            sounds['music']:play()
            sounds['music']:seek(backgroundMusicPosition)
        end
    end
    
    if key == 'escape' then
        love.event.quit()
    end
    
end