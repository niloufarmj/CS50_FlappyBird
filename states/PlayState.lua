PlayState = Class{__includes = BaseState}

local PIPE_DISTANCE_SECONDS = 2
local GAP_HEIGHT = 120

function PlayState:init()
    self.bird = Bird()
    self.pipes = {}
    self.timer = 0
    self.score = 0

    self.lastY = -PIPE_HEIGHT + math.random(80) + 20
end

function PlayState:update(dt)
    -- update timer for pipe spawning
    self.timer = self.timer + dt

    if self.timer > PIPE_DISTANCE_SECONDS then
        local y = math.max(-PIPE_HEIGHT + 40, math.min(self.lastY + math.random(-30, 30), WINDOW.VirtualHeight - 40 - PIPE_HEIGHT))
        self.lastY = y

        local top_color = math.random(0, 1) == 0 and 'blue' or 'pink'
        local bottom_color = top_color == 'blue' and 'pink' or 'blue'

        table.insert(self.pipes, Pipe('top', y, top_color))
        table.insert(self.pipes, Pipe('bottom', y + PIPE_HEIGHT + GAP_HEIGHT, bottom_color))
        self.timer = 0
    end
    
    -- move pipes and remove outside pipes
    for k, pipe in pairs(self.pipes) do
        pipe:update(dt)

        for k, pipe in pairs(self.pipes) do
            if self.bird:collides(pipe) then
                gStateMachine:change('score', {
                    score = self.score
                })
            end

        end

        if pipe.x < -(PIPE_WIDTH + 10)  then
            table.remove(self.pipes, k)
        end
    end

    for k, pipe in pairs(self.pipes) do
        
        if pipe.x + PIPE_WIDTH < self.bird.x and not pipe.scored and pipe.orientation == 'bottom' then
            self.score = self.score + 1
            pipe.scored = true
        end
        
    end

    -- bird jump
    self.bird:update(dt)

    -- reset if we get to the ground
    if self.bird.y > WINDOW.VirtualHeight - GROUND_HEIGHT then
        gStateMachine:change('score', {
            score = self.score
        })
    end
end


function PlayState:render()
    for k, pair in pairs(self.pipes) do
        pair:render()
    end

    love.graphics.setFont(mediumFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)
    self.bird:render()
end