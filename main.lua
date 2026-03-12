love = require("love")

function love.load()
    love.window.setTitle("PEX")

    love.graphics.setDefaultFilter("nearest", "nearest")
    math.randomseed(os.time())
    game = require("source.game")

    love.graphics.setBackgroundColor(0.5, 0.5, 0.5)

    game.functions.startGame()
end

function love.draw()
    game.functions.render()
    love.graphics.setColor(1,0,0)
    love.graphics.rectangle("fill", love.mouse.getX(), love.mouse.getY(), 10, 10)
    love.graphics.setColor(1,1,1)

    love.graphics.print("You have cliked: " .. tostring(math.floor(game.winCond.clicks)) .. " times", 0,0)
end

function love.update(dt)
    
end

function love.mousepressed(x, y, button, istouch)
    if button == 1 then
        for key, value in pairs(game.hitBoxes) do
            if game.functions.AABB(x, y, 5, 5, value.x, value.y, value.w, value.h) then
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
        end
    end
end