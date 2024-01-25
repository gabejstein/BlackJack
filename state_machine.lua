StateMachine = {}
StateMachine.__index = StateMachine

function StateMachine:New(states)
    local this = {
        states = states or {},
        currentState = nil
    }

    setmetatable(this,self)
    return this

end

function StateMachine:ChangeState(stateId)
    --assert(self.states[stateId])
    if self.currentState then
        self.currentState:Exit()
    end
    self.currentState = self.states[stateId]
    self.currentState:Enter()
end

function StateMachine:Update(dt)
    if self.currentState then
        self.currentState:Update(dt)
    end
end

function StateMachine:Render()
    if self.currentState then
        self.currentState:Render()
    end
end