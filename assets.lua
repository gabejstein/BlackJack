gTextures = {
    ["cards"] = love.graphics.newImage("assets/cardsLarge_tilemap_packed.png"),
    ["logo"] = love.graphics.newImage("assets/logo_01.png"),
}

gQuads = {
    ["cards"] = GenerateQuads(gTextures["cards"],CARD_WIDTH,CARD_HEIGHT,11,2)
}

gFonts = {
    ["medium"] = love.graphics.newFont('assets/fonts/pixela-extreme.ttf', 12,"mono"),
}

gSounds = {
    ["cardSlide"] = love.audio.newSource("assets/sounds/kenny/cardSlide2.ogg","static"),
    ["cardPlace"] = love.audio.newSource("assets/sounds/kenny/cardPlace1.ogg","static"),
    ["shuffle"] = love.audio.newSource("assets/sounds/kenny/cardFan1.ogg","static"),
    ["gameOver"] = love.audio.newSource("assets/sounds/kenny/game_over.ogg","static"),
    ["pressEnter"] = love.audio.newSource("assets/sounds/kenny/powerUp8.ogg","static"),
}

