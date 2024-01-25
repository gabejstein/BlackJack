--Very typical linear Tween/Lerp function. By Gabe Stein.

Tween = {}
Tween.__index = Tween

function Tween:New(start, finish, duration, onFinish)
    local this = {
        start = start,
        finish = finish,
        distance = finish - start,
        duration = duration,
        OnFinish = onFinish or function() end,
        time = 0,
        isFinished = false,
        current = start
    }
    setmetatable(this,self)
    
    --avoid division by zero errors
    if this.duration <= 0 then
        this.isFinished = true
    end

    return this
end

function Tween:Update(dt)
    if self.isFinished then return end

    self.time = self.time + dt
    self.current = self.start + (self.distance * (self.time / self.duration))

    if self.time >= self.duration then
        self.current = self.start + self.distance
        self.isFinished = true
        self.OnFinish()
    end
end

function Tween:IsFinished()
    return self.isFinished
end

function Tween:Toggle()
    self.isFinished = not self.isFinished
end

function Tween:Value()
    return self.current
end