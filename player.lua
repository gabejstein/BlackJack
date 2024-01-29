Player = {}
Player.__index = Player

function Player:New(x,y,isDealer)
    local this = {
        hand = {},
        money = 500,
        x = x or 0,
        y = y or 0,
        isDealer = isDealer or false,
        isRevealed = not isDealer
    }
    setmetatable(this,self)

    return this
end

function Player:GetCard(card)
    if #self.hand == 0 and self.isDealer then 
        card.faceDown = true 
        self.isRevealed = false
    end
    table.insert(self.hand,card)
end

function Player:RevealHand()
    for i=1,#self.hand do
        self.hand[i].faceDown = false
    end
    self.isRevealed = true
end

function Player:ResetHand()
    self.hand = {}
end

function Player:GetScore()
    local score = 0
    local aces = {} --store the aces for computing afterwards
    for i=1,#self.hand do
        local card = self.hand[i]
        local value = math.min(10,card.value) --if it's a face card, it should not exceed 10

        --Store the aces after everything else is tallied up.
        if card.value == Ace then
            table.insert(aces,card)
            value = 0
        end

        score = score + value
    end

    --Do aces
    for i=1,#aces do
        if (score + 11) > 21 then
            score = score + 1
        else
            score = score + 11
        end
    end

    return score
end

function Player:CardCount()
    return #self.hand
end

function Player:DisplayHand()
    local x, y = 0,0
    for i=1,#self.hand do
        x = self.x + ((i-1) * (CARD_WIDTH-10))
        y = self.y
        DisplayCard(self.hand[i],x,y)
    end

    if self.isRevealed and #self.hand > 0 then
        love.graphics.setColor(0,0,1,1)
        love.graphics.print(tostring(self:GetScore()),x+47,self.y)
        love.graphics.setColor(1,1,1,1)
    end
    
end

function Player:GetLastCardPosition()
    if #self.hand < 1 then 
        return self.x
    end
    local x = self.x + ((#self.hand) * (CARD_WIDTH-10))
    return x
end