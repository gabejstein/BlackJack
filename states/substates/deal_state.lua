DealState = {}
DealState.__index = DealState

function DealState:New(player, deck, deckX, deckY)
    local this ={
        player = player, --which player to deal a card to.
        deck = deck,
        deckX = deckX,
        deckY = deckY,
        isDone = false
    }
    setmetatable(this,self)

    return this
end

function DealState:UpdateDeck(deck)
    self.deck = deck
end

function DealState:Enter()
    local speed = 0.8
    self.tweenX = Tween:New(self.deckX,self.player:GetLastCardPosition(),speed)
    self.tweenY = Tween:New(self.deckY,self.player.y,speed)
    self.isDone = false
    gSounds["cardSlide"]:play()
end

function DealState:Exit()
    self.player:GetCard(self.deck:GetTop())
    gSounds["cardPlace"]:play()
end

function DealState:Update(dt)

   self.tweenX:Update(dt)
   self.tweenY:Update(dt)

   if self.tweenX:IsFinished() and self.tweenY:IsFinished() then
    self.isDone = true
   end
end

function DealState:Render()
   
    if self.isDone == false then
        love.graphics.draw(gTextures["cards"],gQuads["cards"][FaceDown],self.tweenX:Value(),self.tweenY:Value())
    end
    
end