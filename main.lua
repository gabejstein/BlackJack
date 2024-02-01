require "dependencies"

--Use this to get the mouse position with push
--local x,y = Push:toGame(love.mouse.getPosition())

function love.load()
    love.graphics.setDefaultFilter("nearest","nearest")
    love.window.setTitle("Black Jack")
    --Use the push library to scale the screen
    Push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true,
        canvas = true
    })
    love.window.maximize()

    math.randomseed(os.time())

    --love.graphics.setNewFont(20)
    love.graphics.setFont(gFonts["medium"])

    gStateMachine = StateMachine:New({
        ["start"] = StartMenu:New(),
        ["play"] = PlayState:New(),
        ["gameover"] = GameOverState:New(),
        ["ending"] = EndingState:New(),
    })

    gStateMachine:ChangeState("start")

    --user defined on-keyboard-press table
    love.keyboard.keysPressed = {}

    love.mouse.setVisible(false)

end

local function DrawCursor()
    local x,y = Push:toGame(love.mouse.getPosition())
    if x==nil or y==nil then return end
    x = math.floor(x)
    y = math.floor(y)
    love.graphics.draw(gTextures["cursor"],x,y)
end

function love.update(dt)
    
    gStateMachine:Update(dt)

    love.mouse.keysPressed = {}
    love.mouse.keysReleased = {}
    love.keyboard.keysPressed = {}
end

function love.draw()
    Push:start()
    
        gStateMachine:Render()

        DrawCursor()
    
    Push:finish()
end

function love.resize(w, h)
    Push:resize(w, h)
end

--input callbacks
function love.mousepressed(x, y, key)
    love.mouse.keysPressed[key] = true
end

function love.mousereleased(x, y, key)
    love.mouse.keysReleased[key] = true 
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

function love.mouse.wasPressed(key)
    return love.mouse.keysPressed[key]
end

function love.mouse.wasReleased(key)
    return love.mouse.keysReleased[key]
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

