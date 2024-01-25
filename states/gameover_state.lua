GameOverState = {}
GameOverState.__index = GameOverState

function GameOverState:New()
    local this ={

    }
    setmetatable(this,self)

    return this
end

function GameOverState:Enter()
    self.textTween = Tween:New(-12,VIRTUAL_HEIGHT/2 - 12,2)
    self.fadeTween = Tween:New(1,0,0.5)
    self.playedSound = false
    
end

function GameOverState:Exit()
end

function GameOverState:Update(dt)
    if self.textTween:IsFinished() then
        if love.keyboard.wasPressed("return") or love.mouse.isDown(1) then
            gStateMachine:ChangeState("start")
        end

        if self.playedSound == false then
            gSounds["gameOver"]:play()
            self.playedSound = true
        end
    end

    self.textTween:Update(dt)

    if self.fadeTween:IsFinished() == false then
        self.fadeTween:Update(dt)
    end
    
end

function GameOverState:Render()
    local textY = self.textTween:Value()
    love.graphics.printf("GAME OVER",0,textY,VIRTUAL_WIDTH,"center")

    --fade in/out
    love.graphics.setColor(0,0,0,self.fadeTween:Value())
    love.graphics.rectangle("fill",0,0,VIRTUAL_WIDTH,VIRTUAL_HEIGHT)
    love.graphics.setColor(1,1,1,1)
end