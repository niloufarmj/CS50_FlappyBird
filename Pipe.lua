--[[
    Pipe Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The Pipe class represents the pipes that randomly spawn in our game, which act as our primary obstacles.
    The pipes can stick out a random distance from the top or bottom of the screen. When the player collides
    with one of them, it's game over. Rather than our bird actually moving through the screen horizontally,
    the pipes themselves scroll through the game to give the illusion of player movement.
]]

Pipe = Class{}

-- since we only want the image loaded once, not per instantation, define it externally
local PIPE_IMAGE_BLUE = love.graphics.newImage('assets/blue.png')

local PIPE_IMAGE_PINK = love.graphics.newImage('assets/pink.png')

local PIPE_SCROLL = -60

function Pipe:init()
    self.x = WINDOW.VirtualWidth

    -- set the Y to a random value halfway below the screen
    self.y = math.random(WINDOW.VirtualHeight / 3, WINDOW.VirtualHeight - 50)

    self.width = PIPE_IMAGE_BLUE:getWidth()

    self.image = math.random(0, 1) == 0 and  PIPE_IMAGE_BLUE or PIPE_IMAGE_PINK
end

function Pipe:update(dt)
    self.x = self.x + PIPE_SCROLL * dt
end

function Pipe:render()
    
    love.graphics.draw(self.image, math.floor(self.x + 0.5), math.floor(self.y))
end