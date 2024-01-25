PlayerMoveState = {}
PlayerMoveState.__index = PlayerMoveState

function PlayerMoveState:New(player,stack,dealToPlayerState)
    local this ={
        player = player, --which player to deal a card to.
        isDone = false,
        stack = stack,
        dealToPlayerState = dealToPlayerState,
    }
    setmetatable(this,self)

    local mx = VIRTUAL_WIDTH / 2 - 25
    local my = 0

    this.selectionMenu = {
        x = VIRTUAL_WIDTH/2 - 50,
        y = VIRTUAL_HEIGHT/2 - 50,
        width = 100,
        height = 100,
        hitButton = Button:New(VIRTUAL_WIDTH/2 - 50,VIRTUAL_HEIGHT/2 - 50,100,50,"HIT",
        function()
            --this.stack:Pop()
            this.stack:Push(this.dealToPlayerState)
        end,nil),
        standButton = Button:New(VIRTUAL_WIDTH/2 - 50,VIRTUAL_HEIGHT/2 - 50+50,100,50,"STAND",
        function()
            --this.isDone = true
            this.stack:Pop()
            --TODO: push CPU move state or not
        end,nil),
        isActive = true,
    }

    return this
end

function PlayerMoveState:Enter()
    self.isDone = false
end

function PlayerMoveState:Exit()
end

function PlayerMoveState:Update(dt)
   self:UpdateMenu()
end

function PlayerMoveState:Render()
    self:RenderMenu()
end

function PlayerMoveState:UpdateMenu()
    local x,y = Push:toGame(love.mouse.getPosition())
    self.selectionMenu.hitButton:Update(x,y)
    self.selectionMenu.standButton:Update(x,y)
end

function PlayerMoveState:RenderMenu()
     --TODO: replace below with a panel
     
     self.selectionMenu.hitButton:Render()
     self.selectionMenu.standButton:Render()
end
