StartMenu = {}
StartMenu.__index = StartMenu

local logo = gTextures["logo"]

local logoY = -logo:getHeight()

local gridCols = math.floor(VIRTUAL_WIDTH / CARD_WIDTH) + 2
local gridRows = math.floor(VIRTUAL_HEIGHT / CARD_HEIGHT) 
local cardGrid = {}
local gridX, gridY = -12,0
local yOffset = (CARD_HEIGHT * gridRows-1)

function StartMenu:New()
    local this ={

    }
    setmetatable(this,self)

    return this
end

function StartMenu:Enter()
    logoY = -logo:getHeight()
    local finalY = VIRTUAL_HEIGHT * 0.5 - 80
    self.logoTween = Tween:New(-logo:getHeight(),finalY,1)
    self.fadeTween = Tween:New(0,1,0.6)
    self.startedFade = false
    GenerateGrid()

    self.playedSound = false
end

function StartMenu:Exit()
end

function StartMenu:Update(dt)

    UpdateGrid(dt)

    self.logoTween:Update(dt)
    logoY = self.logoTween:Value()

    if self.logoTween:IsFinished() then
        if self.playedSound == false then
            self.playedSound = true
            gSounds["pressEnter"]:play()
        end
        if love.keyboard.wasPressed("return") or love.mouse.isDown(1) then
            self.startedFade = true
        end
    end

    if self.startedFade then
        self.fadeTween:Update(dt)
        if self.fadeTween:IsFinished() then
            gStateMachine:ChangeState("play")
        end
    end
    
end

function StartMenu:Render()
    --love.graphics.clear(0.5,0.5,0.5,1)
    RenderGrid()

    love.graphics.draw(logo,0,logoY)

    if self.logoTween:IsFinished() then
        love.graphics.printf("PRESS START",0,VIRTUAL_HEIGHT * 0.5,VIRTUAL_WIDTH,"center")
    end

    if self.startedFade then
        love.graphics.setColor(0,0,0,self.fadeTween:Value())
        love.graphics.rectangle("fill",0,0,VIRTUAL_WIDTH,VIRTUAL_HEIGHT)
        love.graphics.setColor(1,1,1,1)
    end
end

function GenerateGrid()
    cardGrid = {}
    for i=1,(gridCols * gridRows) do
        local card = {suit = math.random(1,3),value = math.random(1,12),faceDown = false}
        table.insert(cardGrid,card)
    end
end

function UpdateGrid(dt)

    gridY = gridY + 50 * dt

    if gridY > VIRTUAL_HEIGHT then
        gridY = 0
    end
end

function RenderGrid()
    love.graphics.setColor(1,1,1,0.6)
    for i=1,gridRows do
        for j=1,gridCols do
            local index = (i-1)*gridRows + j

            local x = gridX + ((j-1)*CARD_WIDTH)
            local y = math.floor(gridY + ((i-1)*CARD_HEIGHT))
            
            DisplayCard(cardGrid[index],x,y)

            --shifting and redrawing
            y = math.floor(y - yOffset - 1) --for some reason, a 1 pixel gap works
            DisplayCard(cardGrid[index],x,y)
        end
    end
    love.graphics.setColor(1,1,1,1)
end