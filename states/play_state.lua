PlayState = {}
PlayState.__index = PlayState

local player = Player:New(15,175)
local dealer = Player:New(15,5)

local deckX, deckY = 268,5

local pot = 0

local textBox = Textbox:New(10,100,300,50)

local roundCount = 0 --for keeping track of when the cards should be shuffled.
local roundFinished = false
local gameOver = false

function PlayState:New()
    local this = {
        subStack = StateStack:New(),
    }
    setmetatable(this,self)

    return this
end

function PlayState:Enter()

    self.deck = Deck:New()

    player = Player:New(15,175)
    dealer = Player:New(15,5,true)

    --create states
    --In hindsight, I might just allocate these things during the game.
    --Having these proallocated states creates some problems.
    self.Betting = BettingState:New(player,dealer,self)
    self.DealToPlayer = DealState:New(player,self.deck,deckX,deckY)
    self.DealToDealer = DealState:New(dealer,self.deck,deckX,deckY)
    self.PlayerMove = PlayerMoveState:New(player,self.subStack,self.DealToPlayer)
    self.DealerMove = DealerMoveState:New(dealer,self.subStack,self.DealToDealer,player)
    self.MessageState = MessageState:New(textBox)
    
    textBox.isActive = true

    self.fadeTween = Tween:New(1,0,0.5)

    gameOver = false

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
    self:Message("PLACE YOUR BET")

    roundCount = roundCount + 1
    if roundCount > 5 then
        roundCount = 0
        self.deck = {}
        self.deck = Deck:New()

        --these need to be updated because the deck changed on shuffle
        self.DealToPlayer:UpdateDeck(self.deck)
        self.DealToDealer:UpdateDeck(self.deck)

        gSounds["shuffle"]:play()
        self:Message("Shuffling deck.", function() self:Message("PLACE YOUR BET") end)
    end

end

function PlayState:Exit()
end

function PlayState:Update(dt)

    self.fadeTween:Update(dt)

    self.subStack:Update(dt)

    local playerScore = player:GetScore()
    local dealerScore = dealer:GetScore()

    --check for bust or blackjacks
    if playerScore > 21 or dealerScore > 21 or (playerScore==21 and player:CardCount()==2) or
    (dealerScore==21 and dealer:CardCount()==2) then
        if not roundFinished then
            self.subStack:Clear()
        end
    end

    if self.subStack:Empty() then
        if roundFinished then
             if not gameOver then self:StartNewRound() end
        else
            self:CheckHands(playerScore,dealerScore)
        end
        
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

    --fade in/out
    love.graphics.setColor(0,0,0,self.fadeTween:Value())
    love.graphics.rectangle("fill",0,0,VIRTUAL_WIDTH,VIRTUAL_HEIGHT)
    love.graphics.setColor(1,1,1,1)
   
end

--We're going to check for winners/losers here
function PlayState:CheckHands(playerScore, dealerScore)

    dealer:RevealHand()

    if dealerScore == playerScore then
        self:Message("The game's a push!")
        player.money = player.money + pot / 2
        dealer.money = dealer.money + pot / 2
    elseif dealerScore == 21 and dealer:CardCount()==2 then
        --dealer wins
        self:Message("Black Jack for me! I win!")
        dealer.money = dealer.money + pot
    elseif playerScore == 21 and player:CardCount()==2 then
        --player wins
        self:Message("Black Jack! You win!")
        player.money = player.money + pot
    elseif playerScore > 21 then
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
           self.fadeTween = Tween:New(0,1,3.5,
            function()
                gStateMachine:ChangeState("gameover")
            end)
        end)
        gameOver = true
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

