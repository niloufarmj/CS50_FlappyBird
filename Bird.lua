Bird = Class{}

local GRAVITY = 5

function Bird:init()
    -- load bird image from disk and assign its width and height
    self.image = love.graphics.newImage('assets/bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    -- position bird in the middle of the screen
    self.x = WINDOW.VirtualWidth / 2 - (self.width / 2)
    self.y = WINDOW.VirtualHeight / 2 - (self.height / 2)

    -- y speed
    self.dy = 0
end

function Bird:collides(pipe)
    if (self.x) + (self.width - 8) >= pipe.x and self.x + 8 <= pipe.x + PIPE_WIDTH then
        if (self.y) + (self.height - 8) >= pipe.y and self.y + 8 <= pipe.y + PIPE_HEIGHT then
            return true
        end
    end

    return false
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end

function Bird:update(dt)
    self.dy = self.dy + GRAVITY * dt --acceleration of speed -> v = at

    if love.keyboard.keysPressed['space'] then
        self.dy = -2
    end

    self.y = self.y + self.dy -- y += v
end