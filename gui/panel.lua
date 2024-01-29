Panel = {}
Panel.__index = Panel

function Panel:New(texture,size)

    local this = {
        mTexture = texture,
        mSize = size,
        mQuads = GenerateQuads(texture,size,size),
        isActive = true
    }
    setmetatable(this,self)

    return this

end

function Panel:Render(left,top,right,bottom)

    --draw corners first
    love.graphics.draw(self.mTexture,self.mQuads[1],left,top) --top left
    love.graphics.draw(self.mTexture,self.mQuads[3],right-self.mSize,top)
    love.graphics.draw(self.mTexture,self.mQuads[7],left,bottom-self.mSize)
    love.graphics.draw(self.mTexture,self.mQuads[9],right-self.mSize,bottom-self.mSize)

    --draw horizontal borders
    local widthScale = (math.abs(left-right)-(self.mSize * 2)) / self.mSize
    love.graphics.draw(self.mTexture,self.mQuads[2],left+self.mSize,top,0,widthScale,1)
    love.graphics.draw(self.mTexture,self.mQuads[8],left+self.mSize,bottom-self.mSize,0,widthScale,1)

    --draw vertical borders
    local heightScale = (math.abs(top-bottom)-(self.mSize * 2)) / self.mSize
    love.graphics.draw(self.mTexture,self.mQuads[4],left,top+self.mSize,0,1,heightScale)
    love.graphics.draw(self.mTexture,self.mQuads[6],right-self.mSize,top+self.mSize,0,1,heightScale)

    --draw fill
    love.graphics.draw(self.mTexture,self.mQuads[5],left+self.mSize,top+self.mSize,0,widthScale,heightScale)
end

function Panel:DrawFromCenter(x,y,width,height)
    local halfWidth = width * 0.5
    local halfHeight = height * 0.5
    self:Render(x-halfWidth,y-halfHeight,x+halfWidth,y+halfHeight)
end