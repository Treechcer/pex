game = {
    width = love.graphics.getWidth(),
    height = love.graphics.getHeight(),
    difficulty = {x = 4, y = 4},
    possibleColors = {
        "blue_diamond", "blue_heart", "clubs", "diamond", "heart", "spade", "cyan_clubs", "cyan_spade"
    },
    functions = {},
    hitBoxes = {},
    clickedCard = {x = -1, y = -1},
    lastClick = {x = -1, y = -1},
    UI = {
        offsetX = 200,
        nextCardX = 50,
        offsetY = 100,
        nextCardY = 50
    },
    winCond = {
        found = 0,
        haveToFind = 16
    },
    clickCount = -1
}

game.winCond.haveToFind = game.difficulty.x * game.difficulty.y

game.UI.offsetX = game.width / 2 - (game.UI.nextCardX * (game.difficulty.x / 2))
game.UI.offsetY = game.height / 2 - (game.UI.nextCardY * (game.difficulty.y / 2))

game.sprite = {}

for key, value in pairs(game.possibleColors) do
    game.sprite[value] = love.graphics.newImage("assets/" .. value .. ".png")
end

game.sprite.card_face_down = love.graphics.newImage("assets/" .. "card_face_down" .. ".png")
game.sprite.card_face_up = love.graphics.newImage("assets/" .. "card_face_up" .. ".png")

function game.functions.createButton(X, Y, W, H, Function, sprite, data)
    local t = {x = X, y = Y, w = W, h = H, colFunc = Function, sprite = sprite}
    if data ~= nil then
        t.data = data
    end
    table.insert(game.hitBoxes, t)
end

function game.functions.startGame()
    local colors = {}
    local dimension = game.difficulty.y * game.difficulty.x
    if dimension % 2 == 0 then
        for _ = 1, dimension / 2, 1 do
            local PC = game.possibleColors
            local index = math.random(1, #PC)
            table.insert(colors, {color = PC[index], count = 0})
            table.remove(game.possibleColors, index)
            --print(PC[index])
        end

        for index, value in ipairs(colors) do
            table.insert(game.possibleColors, value.color)
        end
    else
        love.event.quit()
        --temporary??
    end

    for y = 1, game.difficulty.y do
        for x = 1, game.difficulty.x do
            local created = false
            while not created do
                local index = math.random(1, #colors)
                local c = colors[index]
                c.count = c.count + 1
                if c.count <= 2 then
                    --print(c.color)
                    game.functions.createButton(game.UI.offsetX + ((x - 1) * game.UI.nextCardX), game.UI.offsetY + ((y - 1) * game.UI.nextCardY), 48, 48, function (self) game.clickedCard = {x = self.data.posX, y = self.data.posY} end, c.color, {posX = x, posY = y, state = "notFound"})
                    created = true
                end
            end
        end
    end
end

function game.functions.AABB(X1, Y1, W1, H1, X2, Y2, W2, H2)
    --print(X1, Y1, W1, H1, X2, Y2, W2, H2)
    if  X1 < X2 + W2 and
        X1 + W1 > X2 and
        Y1 < Y2 + H2 and
        Y1 + H1 > Y2 then
            return true
    end

    return false
end

function game.functions.render()
    local xc = 1
    local yc = 1

    for index, value in ipairs(game.hitBoxes) do
        --print(game.clickedCard.x, xc, game.clickedCard.y, yc)

        if index > 1 and value.y ~= game.hitBoxes[index-1].y then
            yc = yc + 1
            xc = 1
        end

        if value.data.state == "found" or game.clickedCard.x == xc and game.clickedCard.y == yc or game.lastClick.x == xc and game.lastClick.y == yc then
            local cardSpr = game.sprite.card_face_up
            local colorSpr = game.sprite[value.sprite]
            local mov = 3
            love.graphics.draw(cardSpr, value.x - mov, value.y - mov, 0, 3.5, 3.5)

            local scale = 2
            love.graphics.draw(colorSpr, value.x + (cardSpr:getWidth() * 3.5) / 2 - mov, value.y + (cardSpr:getHeight() * 3.5) / 2 - mov, 0, scale, scale, colorSpr:getWidth() / 2, colorSpr:getHeight() / 2)
        else
            local cardSpr = game.sprite.card_face_down
           love.graphics.draw(cardSpr, value.x, value.y, 0, 3.5, 3.5)
        end

        xc = xc + 1
    end
    --print("---")
end

function game.functions.checkIfWin()
    local winTab = game.winCond
    if winTab.found >= winTab.haveToFind then
        love.event.quit()
    end
end

return game