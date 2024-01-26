Textbox = {}
Textbox.__index = Textbox

function Textbox:New(x,y,w,h)
    local this = {
        x = x,
        y = y,
        w = w,
        h = h,
        padding = 10,
        isActive = false,
        text = "",
        curChar = 1,
        lineSize = 0,
        isDone = false,
    }
    setmetatable(this,self)

    return this
end

function Textbox:SetText(text)
    text = string.upper(text)
    self.text = text
    self.curChar = 1
    self.lineSize = string.len(text)
    self.isDone = false
end

function Textbox:Update(dt)
    if not self.isDone then
        self.curChar = math.min(self.curChar + dt*20, self.lineSize)
        if self.curChar == self.lineSize then
            self.isDone = true
        end

        if love.keyboard.wasPressed("return") or love.mouse.wasPressed(1) then
            self.isDone = true
            self.curChar = self.lineSize
        end
    end
    
end

function Textbox:Render()
    love.graphics.setColor(0,0,0,0.4)
    love.graphics.rectangle("fill",self.x,self.y,self.w,self.h,4,4,6)
    love.graphics.setColor(1,1,1,1)

    local tx = self.x + self.padding
    local ty = self.y + self.padding

    local renderText = string.sub(self.text,1,self.curChar)
    love.graphics.print(renderText,tx,ty)
end