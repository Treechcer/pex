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
        haveToFind = 16,
        clicks = 0,
        time = 0,
        won = false
    },
    clickCount = -1,
    name = "PEX",
    highscores = {
        --{name = "pepaZDepa", clicks = 67, time = 6.7}
        --{name = string, clicks = int, time = float}
    }
}

function game.functions.tableToStr(tbl)
    local str = "{\n"

    for key, value in pairs(tbl) do
        local keyStr

        if type(key) == "number" then
            keyStr = "[" .. key .. "]"
        else
            keyStr = "[\"" .. key .. "\"]"
        end

        if type(value) == "table" then
            str = str .. keyStr .. " = " .. game.functions.tableToStr(value) .. ",\n"
        elseif type(value) == "string" then
            str = str .. keyStr .. " = \"" .. value .. "\",\n"
        else
            str = str .. keyStr .. " = " .. tostring(value) .. ",\n"
        end
    end

    return str .. "}"
end

local metatable = {
    __tostring = function (self)
        return game.functions.tableToStr(self)
    end
}

setmetatable(game.highscores, metatable)
setmetatable(game.hitBoxes, metatable)

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
    num = num or 0
    num = num + 1
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
            if value.data.state == "button_end" then
                local cardSpr = game.sprite.card_face_down -- change this to button later
                love.graphics.draw(cardSpr, value.x, value.y, 0, value.w / cardSpr:getWidth(), value.h / cardSpr:getHeight())
            else
                local cardSpr = game.sprite.card_face_down
                love.graphics.draw(cardSpr, value.x, value.y, 0, 3.5, 3.5)
            end
        end

        xc = xc + 1
    end
    --print("---")
end

function game.functions.restartGame()
    game.winCond = {
        found = 0,
        haveToFind = 16,
        clicks = 0,
        time = 0,
        won = false
    }

    game.clickedCard = {x = -1, y = -1}
    game.lastClick = {x = -1, y = -1}
    game.clickCount = -1

    game.name = "PEX"
    game.hitBoxes = {}
    game.functions.startGame()
end

function game.functions.endScreen()
    local font = love.graphics.getFont()
    local msg = "What's your name?"
    love.graphics.printf(msg, game.width / 2 - 125, game.height / 4 - (25), 250, "center")
    love.graphics.rectangle("fill", game.width / 2 - 125, game.height / 4 - (25/4), 250, 25)

    love.graphics.setColor(0,0,0)
    love.graphics.printf(game.name, game.width / 2 - 125, game.height / 4 - (25/4) + 5, 250, "left")
    love.graphics.setColor(1,1,1)
end

function game.functions.checkIfWin()
    local winTab = game.winCond
    if winTab.found >= winTab.haveToFind then
        winTab.won = true
        game.functions.createButton(game.width / 2 - 125, game.height / 4 - 50, 48, 48, game.functions.restartGame, "card_face_down", {state = "button_end"})
        game.functions.endScreen()
    end
end

function game.functions.createSave()
    save = love.filesystem.newFile("save.lua")
    if save ~= nil then
        save:open("w")
        save:close()
        return save
    end

    return nil
end

function game.functions.save()
    local hs = tostring(game.highscores)
    print(hs)
    save = game.functions.createSave()
    save:open("w")
    save:write("a = " .. tostring(hs) .. "\nreturn a")
    save:close()
end

function game.functions.load()
    local a = love.filesystem.load("save.lua")

    if a ~= nil then
        metatable = {
            __tostring = function (self)
                return game.functions.tableToStr(self)
            end
        }
        local temp = a()
        if temp ~= nil then
            game.highscores = a()
            setmetatable(game.highscores, metatable)
        end
    end

    return game.highscores
end

return game