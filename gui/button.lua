Button = {}
Button.__index = Button

function Button:New(x,y,w,h,text,callback,params)
    local this ={
        x = x,
        y = y,
        text = text,
        w = w,
        h = h,
        callback = callback or function(params) end,
        params = params or nil,
        isDown = false
    }
    setmetatable(this,self)
    return this
end

function Button:Update(mouseX,mouseY)
    if mouseX == nil or mouseY == nil then return end

    self.isDown = false

    if mouseX >= self.x and mouseX <= self.x + self.w and mouseY >= self.y and mouseY <= self.y + self.h then
        if love.mouse.isDown(1) then
            self.isDown = true
        end
        
        if love.mouse.wasReleased(1) then
            self.callback(self.params)
        end
    end
end

function Button:Render()
    --need to round down to prevent blurring
    local mx,my = math.floor(self.x),math.floor(self.y)
    if self.isDown then
        love.graphics.setColor(0,0,1,1)
    else
        love.graphics.setColor(1,0,1,1)
    end
    
    love.graphics.rectangle("fill",mx,my,self.w,self.h)
    love.graphics.setColor(1,1,1,1)
    love.graphics.rectangle("line",mx,my,self.w,self.h)

    love.graphics.print(self.text,mx+5,my+5)
end