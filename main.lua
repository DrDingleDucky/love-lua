function love.load()
    w = 0
    h = 0
    x = 0
    y = 0
    t = 0
end

function love.update(dt)
    if (t <= 0) then
        w = math.random(50, 200)
        h = math.random(50, 200)
        x = love.graphics.getWidth() / 2 - w / 2
        y = love.graphics.getHeight() / 2 - h / 2
        t = 1
    else
        t = t - dt
    end
end

function love.draw()
    love.graphics.setColor(0, 0.4, 0.4)
    love.graphics.rectangle("fill", x, y, w, h)
end
