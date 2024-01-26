BettingState = {}
BettingState.__index = BettingState

local bettingIncrement = 10

function BettingState:New(player, dealer,playState)
    local this ={
        player = player,
        dealer = dealer,
        isDone = false,
        playState = playState,
        bet = 0,
    }
    setmetatable(this,self)

    local mx = VIRTUAL_WIDTH - 55
    local my = VIRTUAL_HEIGHT / 2 - 25

    this.bettingMenu = {
        x = mx,
        y = my,
        upButton  = Button:New(mx,my,50,20,"UP",function() this:OnUpButton() end,nil),
        downButton  = Button:New(mx,my+20,50,20,"DOWN",function() this:OnDownButton() end,nil),
        okButton = Button:New(mx,my+40,50,20,"OK",function() this:OnOkButton() end,nil),
    }

    this.messageState = MessageState:New("You have to bet more than 0!")

    return this
end

function BettingState:Enter()
    self.isDone = false
    self.bet = 0
    
end

function BettingState:Exit()
end

function BettingState:Update(dt)
   self:UpdateMenu()
end

function BettingState:Render()
    self:RenderMenu()
end

function BettingState:UpdateMenu()
    local x,y = Push:toGame(love.mouse.getPosition())
    self.bettingMenu.upButton:Update(x,y)
    self.bettingMenu.downButton:Update(x,y)
    self.bettingMenu.okButton:Update(x,y)
end

function BettingState:RenderMenu()
    self.bettingMenu.upButton:Render()
    self.bettingMenu.downButton:Render()
    self.bettingMenu.okButton:Render()
end

function BettingState:OnOkButton()
    if self.bet <= 0 then
        self.playState:Message("YOU NEED TO BET MORE THAN THAT!", function()self.playState:Message("PLACE YOUR BET")end)
        return
    end
    
    --Have the dealer throw in their money.
    self.dealer.money = self.dealer.money - self.bet
    self.bet = self.bet + self.bet
    SetPot(self.bet)

    self.isDone = true
end

function BettingState:OnDownButton()
    if self.bet <=0 then return end
    self.bet = self.bet - bettingIncrement
    self.player.money = self.player.money + bettingIncrement
    SetPot(self.bet)
end

function BettingState:OnUpButton()
    if bettingIncrement > self.player.money then return end
    self.player.money = self.player.money - bettingIncrement
    self.bet = self.bet + bettingIncrement
    SetPot(self.bet)
end