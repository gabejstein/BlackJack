DealerMoveState = {}
DealerMoveState.__index = DealerMoveState

function DealerMoveState:New(dealer,stack,dealToDealerState, player)
    local this ={
        dealer = dealer, --which player to deal a card to.
        isDone = false,
        stack = stack,
        dealToDealerState = dealToDealerState,
        player = player
    }
    setmetatable(this,self)

    return this
end

function DealerMoveState:Enter()
    self.isDone = false
end

function DealerMoveState:Update(dt)
   local score = self.dealer:GetScore()
   local playerScore = self.player:GetScore()

   --take a chance if the player is ahead, otherwise play it safe.
   if score < 17 and playerScore > score and playerScore < 22 then
        self.stack:Push(self.dealToDealerState)
        
   elseif score < 15 then
        self.stack:Push(self.dealToDealerState)
        
   else
        self.isDone = true
   end
end

function DealerMoveState:Exit()
end

function DealerMoveState:Render()
end
