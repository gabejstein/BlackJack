MessageState = {}
MessageState.__index = MessageState

function MessageState:New(textBox, OnFinish)
    local this ={
        isDone = false,
        textBox = textBox,
        timer = 0,
        waitTime = 1,
        onFinish = OnFinish or function() end
    }
    setmetatable(this,self)

    return this
end

function MessageState:SetText(text, onFinish)
    self.textBox:SetText(text)
    self.onFinish = onFinish or function() end
    self.isDone = false
    self.timer = 0
end

function MessageState:Enter()
    self.isDone = false
    self.timer = 0
end

function MessageState:Update(dt)
   self.textBox:Update(dt)

    if self.textBox.isDone then
        self.timer = self.timer + dt
        if self.timer > self.waitTime then
                self.isDone = true
                self.onFinish()
                self.onFinish = function() end
        end
    end
   
end

function MessageState:Exit()
    
end

function MessageState:Render()
end
