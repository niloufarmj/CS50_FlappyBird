Pipe = Class{}

local PIPE_IMAGE_BLUE = love.graphics.newImage('assets/blue.png')
local PIPE_IMAGE_PINK = love.graphics.newImage('assets/pink.png')
local PIPE_IMAGE_BLUE_REVERSED = love.graphics.newImage('assets/blue-reversed.png')
local PIPE_IMAGE_PINK_REVERSED = love.graphics.newImage('assets/pink-reversed.png')

PIPE_SPEED = 90
PIPE_HEIGHT = 200
PIPE_WIDTH = 70

function Pipe:init(orientation, y, color)
    self.x = WINDOW.VirtualWidth
    self.y = y
    self.orientation = orientation
    self.color = color
    self.scored = false

    if color == 'pink' and orientation == 'bottom' then
        self.image = PIPE_IMAGE_PINK
    elseif color == 'blue' and orientation == 'bottom' then
        self.image = PIPE_IMAGE_BLUE
    elseif color == 'pink' and orientation == 'top' then
        self.image = PIPE_IMAGE_PINK_REVERSED
    else
        self.image = PIPE_IMAGE_BLUE_REVERSED
    end

    self.width = self.image:getWidth()
    self.height = PIPE_HEIGHT

end

function Pipe:update(dt)
    self.x = self.x - PIPE_SPEED * dt
end

function Pipe:render()
    
    love.graphics.draw(self.image, math.floor(self.x + 0.5), math.floor(self.y))
end