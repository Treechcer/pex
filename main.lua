love = require("love")

function love.load()
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
end

function love.update(dt)
    
end

function love.mousepressed(x, y, button, istouch)
    if button == 1 then
        for key, value in pairs(game.hitBoxes) do
            if game.functions.AABB(x, y, 5, 5, value.x, value.y, value.w, value.h) then
                local card = {x = game.clickedCard.x, y = game.clickedCard.y}
                value.colFunc(game.hitBoxes[key])
                if card.x == -1 or card.y == -1 then
                    break
                end
                if card.x ~= game.clickedCard.x and card.y ~= game.clickedCard.y then
                    for key_, value_ in pairs(game.hitBoxes) do
                        if value.sprite == value_.sprite then
                            love.event.quit()
                        end
                    end
                end

                break
            end
        end
    end
end