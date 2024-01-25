PlayState = {}
PlayState.__index = PlayState

local player = Player:New(15,175)
local dealer = Player:New(15,5)
local players = {}

local deckX, deckY = 268,5

local pot = 0

local textBox = Textbox:New(10,100,300,50)

local roundCount = 0 --for keeping track of when the cards should be shuffled.
local roundFinished = false

function PlayState:New()
    local this = {
        subStack = StateStack:New(),
    }
    setmetatable(this,self)

    return this
end

function PlayState:Enter()

    players = {}
    self.deck = Deck:New()

    player = Player:New(15,175)
    dealer = Player:New(15,5,true)

    table.insert(players,dealer)
    table.insert(players,player)

    --create states
    self.Betting = BettingState:New(player,dealer,self)
    self.DealToPlayer = DealState:New(player,self.deck,deckX,deckY)
    self.DealToDealer = DealState:New(dealer,self.deck,deckX,deckY)
    self.PlayerMove = PlayerMoveState:New(player,self.subStack,self.DealToPlayer)
    self.DealerMove = DealerMoveState:New(dealer,self.subStack,self.DealToDealer,player)
    self.MessageState = MessageState:New(textBox)

    textBox:SetText("WHAT WILL YOU DO?")
    textBox.isActive = true

    self.fadeTween = Tween:New(1,0,0.5)

    self:StartNewRound()
end

function PlayState:StartNewRound()
    roundFinished = false
    pot = 0
    player:ResetHand()
    dealer:ResetHand()

    self.subStack:Push(self.DealerMove)
    self.subStack:Push(self.PlayerMove)
    self.subStack:Push(self.DealToDealer)
    self.subStack:Push(self.DealToPlayer)
    self.subStack:Push(self.DealToDealer)
    self.subStack:Push(self.DealToPlayer)
    self.subStack:Push(self.Betting)
    textBox:SetText("PLACE YOUR BET") --note: the textboxes are currently only able to take 1 string at a time

    roundCount = roundCount + 1
    if roundCount > 5 then
        roundCount = 0
        self.deck = {}
        self.deck = Deck:New()

        --these need to be updated because the deck changed on shuffle
        self.DealToPlayer:UpdateDeck(self.deck)
        self.DealToDealer:UpdateDeck(self.deck)

        gSounds["shuffle"]:play()
        self:Message("Shuffling deck.")
    end
end

function PlayState:Exit()
end

function PlayState:Update(dt)

    self.subStack:Update(dt)

    if self.subStack:Empty() then
        if roundFinished then
            self:StartNewRound()
        else
            self:CheckHands()
        end
        
    end

    if self.fadeTween:IsFinished() == false then
        self.fadeTween:Update(dt)
    end

end

function PlayState:Render()
    love.graphics.clear(0,0.6,0,1)

    
    player:DisplayHand()
    dealer:DisplayHand()

    --Draw player's money
    local label = string.format("PLAYER MONEY: %d",player.money)
    love.graphics.print(label, player.x + 150, VIRTUAL_HEIGHT * 0.5 + 35)
    --Draw dealer's
    label = string.format("DEALER MONEY: %d",dealer.money)
    love.graphics.print(label, dealer.x + 150, VIRTUAL_HEIGHT * 0.5 - 38)
    --Draw Pot
    label = string.format("POT: %d",pot)
    love.graphics.print(label, 10, VIRTUAL_HEIGHT * 0.5 - 38)
    
    
    --Draw the deck pile
    love.graphics.draw(gTextures["cards"],gQuads["cards"][FaceDown],deckX,deckY)

    if textBox.isActive then
        textBox:Render()
    end

    self.subStack:Render()

    --To test deck
    --[[love.graphics.setColor(1,0,0,1)
    local cardsLeft = string.format("Cards left: %d",self.deck:Count())
    love.graphics.print(cardsLeft,0,0)]]

    --fade in/out
    love.graphics.setColor(0,0,0,self.fadeTween:Value())
    love.graphics.rectangle("fill",0,0,VIRTUAL_WIDTH,VIRTUAL_HEIGHT)
    love.graphics.setColor(1,1,1,1)
   
end

--We're going to check for winners/losers here
function PlayState:CheckHands()
    local playerScore = player:GetScore()
    local dealerScore = dealer:GetScore()

    dealer:RevealHand()

    if dealerScore == playerScore then
        self:Message("THE GAME'S A PUSH!")
        player.money = player.money + pot / 2
        dealer.money = dealer.money + pot / 2
    --[[elseif dealerScore == 21 then
        --dealer wins
        textBox:SetText("21 for me! I win!")
        dealer.money = dealer.money + pot

    elseif playerScore == 21 then
        --player wins
        textBox:SetText("Black Jack! You win!")
        player.money = player.money + pot]]
    elseif playerScore > 21 then --should really check only after player's turn
        self:Message("YOU'RE BUSTED!")
        dealer.money = dealer.money + pot
    elseif dealerScore > 21 then
        self:Message("I'm busted! You win!")
        player.money = player.money + pot
    elseif dealerScore > playerScore then
        self:Message("I WIN!")
        dealer.money = dealer.money + pot
    elseif playerScore > dealerScore then
        self:Message("YOU WIN!")
        player.money = player.money + pot
    end

    --Check for game over condition, otherwise restart
    if player.money <= 0 then
        self:Message("You're out of money. You're done!", 
        function()
            self.fadeTween = Tween:New(0,1,2,
            function()
                gStateMachine:ChangeState("gameover") 
            end)
        end)
        
    elseif dealer.money <= 0 then
        self:Message("I'm out of money! I'm finished for the day.")
      
    end

    roundFinished = true

end

function PlayState:Message(text,onFinish)
    self.MessageState:SetText(text,onFinish)
    self.subStack:Push(self.MessageState)
end

function SetPot(amount)
    pot = amount
end

