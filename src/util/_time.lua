local Time = {}
Time.__index = Time

Time.timers = {}
Time.DeltaTime = 0
Time.AverageDeltaTime = 0
Time.FPS = 0

function Time.Update()
    Time.DeltaTime = love.timer.getDelta()
    Time.AverageDeltaTime = love.timer.getAverageDelta()
    Time.FPS = love.timer.getFPS()

    for k, v in pairs(Time.timers) do
        local timer = v
        if not timer or timer.finished then
            Time.RemoveTimer(k)
            break
        end
        timer:Update()
    end
end

function Time.AddTimer(timerObject)
    Time.timers[timerObject.identifier] = timerObject
end

function Time.RemoveTimer(identifier)
    Time.timers[identifier] = nil
end

function _G.CurTime()
    return love.timer.getTime()
end

_G.Time = Time

local timer = {}
timer.__index = timer

function timer:Start()
    self.startTime = love.timer.getTime()
end

function timer:Update()
    if (not self.startTime) then return end
    if (self.finished) then return end

    self.elapsedTime = love.timer.getTime() - self.startTime

    if self.elapsedTime >= self.length then
        self.iteration = self.iteration + 1
        self.callback()

        if self.iterations ~= 0 and self.iteration >= self.iterations then
            self.finished = true
            Time.RemoveTimer(self.identifier)
        else
            self.startTime = love.timer.getTime()
        end
    end
end

function _G.TimerCreate(identifier, length, iterations, callback)
    local _timer = {}
    setmetatable(_timer, timer)

    _timer.identifier = identifier
    _timer.length = length
    _timer.iterations = iterations
    _timer.callback = callback

    _timer.startTime = 0
    _timer.elapsedTime = 0
    _timer.iteration = 0
    _timer.finished = false

    Time.AddTimer(_timer)
    _timer:Start()

    return _timer
end

function _G.TimerRemove(identifier)
    Time.RemoveTimer(identifier)
end

function _G.TimerExists(identifier)
    for i = 1, #Time.timers do
        local timer = Time.timers[i]
        if timer.identifier == identifier then
            return true
        end
    end
    return false
end
