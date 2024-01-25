StateStack = {}
StateStack.__index = StateStack

function StateStack:New()
    local this = {
        states = {}
    }

    setmetatable(this,self)
    return this

end

function StateStack:Push(state)
    table.insert(self.states,state)
    state:Enter()
end

function StateStack:Pop()
    
    local top = table.remove(self.states)
    top:Exit()

    if #self.states < 1 then return end
    self.states[#self.states]:Enter()
end

function StateStack:Update(dt)
    if #self.states < 1 then return end

    local top = self.states[#self.states]
    top:Update(dt)

    if top.isDone then
        self:Pop()
    end
end

function StateStack:Render()
    if #self.states < 1 then return end
    self.states[#self.states]:Render()
end

function StateStack:Empty()
    return #self.states <= 0
end

function StateStack:Clear()
    self.states = {}
end