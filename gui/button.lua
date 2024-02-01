Button = {}
Button.__index = Button

--decided to make these static objects to save memory.
local sPanel = Panel:New(gTextures["panel_02"],9)
local sDownColor = {red = 222/256,green = 111/256, blue = 127/256, alpha = 1}
local sHoverColor = {red = 198/256,green = 210/256, blue = 139/256, alpha = 1}

function Button:New(x,y,w,h,text,callback,params)
    local this ={
        x = x,
        y = y,
        text = text,
        w = w,
        h = h,
        callback = callback or function(params) end,
        params = params or nil,
        isDown = false,
        isHovering = false,
        fontSize = 12,
        textWidth = gFonts["medium"]:getWidth(text)
    }
    setmetatable(this,self)
    return this
end

function Button:Update(mouseX,mouseY)
    if mouseX == nil or mouseY == nil then return end

    self.isDown = false
    self.isHovering = false

    if mouseX >= self.x and mouseX <= self.x + self.w and mouseY >= self.y and mouseY <= self.y + self.h then
        if love.mouse.isDown(1) then
            self.isDown = true
        else
            self.isHovering = true
        end
        
        if love.mouse.wasReleased(1) then
            self.callback(self.params)
        end
    end
end

function Button:Render()
    --need to round down to prevent blurring
    local mx,my = math.floor(self.x),math.floor(self.y)

    --onclick
    if self.isDown then
        love.graphics.setColor(sDownColor.red,sDownColor.green,sDownColor.blue,sDownColor.alpha)
    elseif self.isHovering then
        love.graphics.setColor(sHoverColor.red,sHoverColor.green,sHoverColor.blue,sHoverColor.alpha)
        --love.graphics.rectangle("fill",mx + 10,my + 10,self.w-10,self.h-10)
    end

    sPanel:Render(mx,my,mx+self.w,my+self.h)

    local tx,ty = mx + (self.w * 0.5 - self.textWidth * 0.5),my + (self.h * 0.5 - self.fontSize * 0.5)-1
    tx, ty = math.floor(tx), math.floor(ty)
    love.graphics.print(self.text,tx,ty)

    love.graphics.setColor(1,1,1,1)
end