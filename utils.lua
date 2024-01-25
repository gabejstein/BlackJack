function GenerateQuads(texture,tileWidth,tileHeight,horizontalPadding,verticalPadding)
    --padding is assumed to be on both sides of the tile
    horizontalPadding = horizontalPadding or 0
    verticalPadding = verticalPadding or 0

    local cellWidth = tileWidth + horizontalPadding * 2
    local cellHeight = tileHeight + verticalPadding * 2

    local sheetWidth = texture:getWidth() / cellWidth
    local sheetHeight = texture:getHeight() / cellHeight
    local counter = 1

    local quads = {}

    for y = 0, sheetHeight-1 do
        for x = 0, sheetWidth-1 do
            quads[counter] = love.graphics.newQuad(
                x * cellWidth + horizontalPadding, y * cellHeight + verticalPadding,
                tileWidth,tileHeight,texture:getDimensions()
            )
            counter = counter + 1
        end
    end

    return quads
end