MessageState = {}
MessageState.__index = MessageState

function MessageState:New(textBox, OnFinish)
    local this ={
        isDone = false,
        textBox = textBox,
        timer = 0,
        waitTime = 1.5,
        onFinish = OnFinish or function() end
    }
    setmetatable(this,self)

    return this
end

function MessageState:SetText(text, onFinish)
    self.textBox:SetText(text)
    self.onFinish = onFinish or function() end
end

function MessageState:Enter()
    self.isDone = false
    self.timer = 0
end

function MessageState:Update(dt)
   self.timer = self.timer + dt
   if self.timer > self.waitTime then
        self.isDone = true
        
   end
end

function MessageState:Exit()
    self.onFinish()
end

function MessageState:Render()
end
