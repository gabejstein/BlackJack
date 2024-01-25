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
        text = ""
    }
    setmetatable(this,self)

    return this
end

function Textbox:SetText(text)
    self.text = text
end

function Textbox:Render()
    love.graphics.setColor(0,0,0,0.4)
    love.graphics.rectangle("fill",self.x,self.y,self.w,self.h,4,4,6)
    love.graphics.setColor(1,1,1,1)

    local tx = self.x + self.padding
    local ty = self.y + self.padding

    love.graphics.print(self.text,tx,ty)
end