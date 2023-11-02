PlayState = Class{__includes = BaseState}

local INITIAL_GAP_HEIGHT = 90 
local MIN_GAP_HEIGHT = 90
local MAX_GAP_HEIGHT = 140

local MAX_SPWAN_TIME = 4
local MIN_SPAWN_TIME = 2

function PlayState:init()
    self.bird = Bird()
    self.pipes = {}
    self.timer = 0
    self.score = 0
    self.currentGapHeight = INITIAL_GAP_HEIGHT
    self.spawnTime = MAX_SPWAN_TIME

    self.lastY = -PIPE_HEIGHT + math.random(80) + 20
end

function PlayState:update(dt)
    -- update timer for pipe spawning
    self.timer = self.timer + dt

    if self.timer > self.spawnTime then
        local y = math.max(-PIPE_HEIGHT + 40, math.min(self.lastY + math.random(-30, 30), WINDOW.VirtualHeight - 40 - PIPE_HEIGHT))
        self.lastY = y

        local top_color = math.random(0, 1) == 0 and 'blue' or 'pink'
        local bottom_color = top_color == 'blue' and 'pink' or 'blue'

        -- calculate gap height
        -- a number between -30 to 30 is added to the gap height randomly each time
        -- gap height is always between min and max values
        local range = math.min(30, math.min(MAX_GAP_HEIGHT - self.currentGapHeight, self.currentGapHeight - MIN_GAP_HEIGHT))
        self.currentGapHeight = self.currentGapHeight + math.random(-range, range)
        self.currentGapHeight = math.min(MAX_GAP_HEIGHT - math.random(0, 15), math.max(MIN_GAP_HEIGHT + math.random(0, 15), self.currentGapHeight))

        table.insert(self.pipes, Pipe('top', y, top_color))
        table.insert(self.pipes, Pipe('bottom', y + PIPE_HEIGHT + self.currentGapHeight, bottom_color))

        self.spawnTime = MIN_SPAWN_TIME + (math.random(-20, 250) / 100) * (MAX_SPWAN_TIME / (self.score * 0.7 + 1))

        self.spawnTime = math.max(self.spawnTime, MIN_SPAWN_TIME) -- ensure the minimum spawn time is 2 seconds
        self.spawnTime = math.min(MAX_SPWAN_TIME, self.spawnTime) -- ensure the minimum spawn time is 4 seconds

        self.timer = 0
    end
    
    -- move pipes and remove outside pipes
    for k, pipe in pairs(self.pipes) do
        pipe:update(dt)

        for k, pipe in pairs(self.pipes) do
            if self.bird:collides(pipe) then
                sounds['explosion']:play()
                sounds['hurt']:play()
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
            sounds['score']:play()

            if self.score >= 30 then
                gStateMachine:change('score', {
                    score = self.score
                })
            end
        end
        
    end

    -- bird jump
    self.bird:update(dt)

    -- reset if we get to the ground
    if self.bird.y > WINDOW.VirtualHeight - GROUND_HEIGHT then
        sounds['explosion']:play()
        sounds['hurt']:play()
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