Deck = {}
Deck.__index = Deck

Heart = 1
Diamond = 2
Club = 3
Spade = 4

Ace = 1
Jack = 11
Queen = 12
King = 13

--sprite sheet index number
FaceDown = 28

function Deck:New()
    local this = {
        cards = {},
    }
    setmetatable(this,self)

    this:GenerateCards()
    this:Shuffle()

    return this
end

function Deck:GenerateCards()
    for suit = 1,4 do
        for value = 1,13 do
            local card = {
                suit = suit,
                value = value,
                faceDown = false
            }
            table.insert(self.cards,card)
        end
    end
end

function Deck:Shuffle()
    for i=1,#self.cards do
        local tempCard = self.cards[i]
        local rIndex = math.random(i+1,52-1)
        self.cards[i] = self.cards[rIndex]
        self.cards[rIndex] = tempCard
    end
end

function Deck:GetTop()
    if #self.cards > 0 then
        local card = table.remove(self.cards)
        return card
    end

    --return a joker to test for nil
    return {suit = 3, value = 14, faceDown = false}
end

function Deck:Count()
    return #self.cards
end

function DisplayCard(card, x, y)
    if card.faceDown == false then
        local rowLength = 14
        local cardIndex = (card.suit-1)*rowLength + card.value
        love.graphics.draw(gTextures["cards"],gQuads["cards"][cardIndex],x,y)
    else
        love.graphics.draw(gTextures["cards"],gQuads["cards"][FaceDown],x,y)
    end
end

--Just a helper function for testing
function DisplayAllCards(deck)
    local rows = 4
    local cols = 13
    for i = 1 , rows do
        for j = 1, cols do
            local card = deck.cards[(i-1)* cols + j]
            
             DisplayCard(card , j*42 + j *10,i*60 + i*10)
           
        end 
    end
end