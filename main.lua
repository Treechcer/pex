love = require("love")

function love.load()
    love.window.setTitle("PEX")

    love.graphics.setDefaultFilter("nearest", "nearest")
    math.randomseed(os.time())
    game = require("source.game")
    backgroud = require("source.backgroud")
    
    love.graphics.setBackgroundColor(1,1,1)
    game.functions.startGame()
end

function love.draw()
    backgroud.functions.render()
    game.functions.render()
    love.graphics.setColor(1,0,0)
    love.graphics.rectangle("fill", love.mouse.getX(), love.mouse.getY(), 10, 10)
    love.graphics.setColor(0,0,0)

    love.graphics.printf("You have clicked: " .. tostring(math.floor(game.winCond.clicks)) .. " times\n" ..
    "You have played for " .. tostring(math.floor(game.winCond.time * 10) / 10) .. " seconds", game.height / 2, 25, 200, "center")
    love.graphics.setColor(1,1,1)
    if game.winCond.won then
        game.functions.endScreen()
    end
end

function love.update(dt)
    --game.functions.save()
    backgroud.functions.move(dt)
    if not game.winCond.won then
        game.winCond.time = game.winCond.time + dt 
    end
end

function love.mousepressed(x, y, button, istouch)
    if button == 1 then
        for key, value in pairs(game.hitBoxes) do
            if game.functions.AABB(x, y, 5, 5, value.x, value.y, value.w, value.h) then
                --print(value.data.state)
                if value.data.state == "button_end" then
                    value.colFunc()
                    return
                end

                if game.winCond.won then
                    goto continue
                end

                game.clickCount = game.clickCount + 1
                game.winCond.clicks = game.winCond.clicks + 0.5
                if game.clickCount >= 2 then
                    game.clickedCard.x = -1
                    game.clickedCard.y = -1
                    game.clickCount = 0
                end
                game.lastClick = {x = game.clickedCard.x, y = game.clickedCard.y}

                --if game.hitBoxes[key].data.state == "found" then
                --    break
                --end

                value.colFunc(game.hitBoxes[key])
                if game.lastClick.x == -1 or game.lastClick.y == -1 or game.clickedCard.x == -1 or game.clickedCard.y == -1 then
                    break
                end

                if game.lastClick.x ~= game.clickedCard.x or game.lastClick.y ~= game.clickedCard.y then
                    for key_, value_ in pairs(game.hitBoxes) do
                        if value_.data.posX == game.lastClick.x and value_.data.posY == game.lastClick.y and value.sprite == value_.sprite then
                            value_.data.state = "found"
                            value.data.state = "found"
                            game.winCond.found = game.winCond.found + 2
                            game.functions.checkIfWin()
                            break
                        end
                    end
                end

                break
            end

            ::continue::
        end
    end
end

function love.keypressed(k)

    if k == "r" then
        game.winCond.won = true
        game.functions.createButton(game.width / 2 - 125, game.height / 4 - 50, 48, 48, game.functions.restartGame, "card_face_down", {state = "button_end"})
        return
    end

    if not game.winCond.won then
        return
    end

    k = (k == "space") and " " or k

    if k:len() == 1 then
        game.name = game.name .. k
    elseif k == "backspace" and game.name:len() >= 1 then
        game.name = game.name:sub(1, game.name:len() - 1)
    elseif k == "return" then
        game.functions.restartGame()
    end

    --print(game.name)
end