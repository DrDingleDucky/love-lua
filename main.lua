-- this function is called exactly once at the beginning of the game
function love.load()
    love.window.setTitle("Lua Game")
    love.window.setMode(1200, 860)

    player = {}
    player.x = love.graphics.getWidth() / 2
    player.y = love.graphics.getHeight() / 2
    player.force = 715
    player.gravity = 850
    player.radius = 32
    player.angle = 0
    player.dx = 0
    player.dy = 0
end

-- callback function triggered when a key is pressed
function love.keypressed(key, scancode, isrepeat)
    if key == "escape" then
        love.event.quit()
    end
end

-- callback function triggered when a mouse button is pressed
function love.mousepressed(x, y, button, istouch)
    if button == 1 then
        local angle = math.atan2(y - player.y, x - player.x)
        player.dx = math.cos(angle) * -player.force
        player.dy = math.sin(angle) * -player.force
    end
end

-- callback function used to update the state of the game every frame
function love.update(dt)
    local x, y = love.mouse.getPosition( )
    player.angle = math.atan2(y - player.y, x - player.x)
    if player.x < 0 + player.radius then
        player.dx = math.abs(player.dx)
    elseif player.x > love.graphics.getWidth() - player.radius then
        player.dx = -math.abs(player.dx)
    end
    player.x = player.x + player.dx * dt
    player.dy = player.dy + player.gravity * dt
    player.y = player.y + player.dy * dt
end

-- callback function used to draw on the screen every frame
function love.draw()
    love.graphics.setBackgroundColor(1, 0.5, 0.5)
    love.graphics.setColor(0.5, 0.5, 1)
    love.graphics.circle("fill", player.x, player.y, player.radius)
    
    love.graphics.translate(player.x, player.y)
    love.graphics.rotate(player.angle)
    love.graphics.translate(-player.x, -player.y)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", player.x, player.y - 7, 64, 14)
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("fill", player.x, player.y, player.radius - player.radius / 2)
end
