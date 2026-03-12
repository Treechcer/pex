backgroud = {
    spacing = 100,
    size = 15,
    speed = {x = 25, y = 20},
    balls = {

    },
    functions = {

    }
}

function backgroud.functions.newBall(x, y)
    table.insert(backgroud.balls, {startX = x, x = x, startY = y, y = y})
end

function backgroud.functions.render()
    love.graphics.setColor(255/255, 182/255, 218/255)
    for key, value in pairs(backgroud.balls) do
        love.graphics.circle("fill", value.x, value.y, backgroud.size)
    end
    love.graphics.setColor(1,1,1)
end

function backgroud.functions.move(dt)
    for _, value in pairs(backgroud.balls) do
        value.x = value.x + backgroud.speed.x * dt
        value.y = value.y + backgroud.speed.y * dt

        if value.x > game.width + backgroud.spacing then
            value.x = value.x - (game.width + backgroud.spacing * 2)
        end

        if value.y > game.height + backgroud.spacing then
            value.y = value.y - (game.height + backgroud.spacing * 2)
        end
    end
end

local counter = 0

for y = -backgroud.spacing * 1.1, game.height + backgroud.spacing * 1.1, backgroud.spacing do
    counter = counter + 1
    for x = -backgroud.spacing * 1.1, game.width + backgroud.spacing * 1.1, backgroud.spacing do
        local XM = x
        if counter % 2 == 0 then
            XM = x + (backgroud.spacing * 0.5)
        end
        backgroud.functions.newBall(XM, y)
    end
end

return backgroud