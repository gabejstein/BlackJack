EndingState = {}
EndingState.__index = EndingState

function EndingState:New()
    local this = {
        waitTime = 4,
    }
    setmetatable(this,self)

    return this
end

function EndingState:Enter()
    self.fadeTween = Tween:New(1,0,0.5)
    self.time = 0
end

function EndingState:Exit()
end

function EndingState:Update(dt)
    self.time = self.time + dt
    if self.time >= self.waitTime then
        if love.keyboard.wasPressed("return") or love.mouse.isDown(1) then
            gStateMachine:ChangeState("start")
        end

    end

    self.fadeTween:Update(dt)
   
end

function EndingState:Render()
    local message = "Good job you have beaten your opponent. You are now the king of Vegas."
    .." Don't forget that winners never do drugs. Thanks for playing! \n\n THE END"

    love.graphics.printf(message,0,50,VIRTUAL_WIDTH,"left")

    --fade in/out
    love.graphics.setColor(0,0,0,self.fadeTween:Value())
    love.graphics.rectangle("fill",0,0,VIRTUAL_WIDTH,VIRTUAL_HEIGHT)
    love.graphics.setColor(1,1,1,1)
end