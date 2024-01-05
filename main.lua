-- this function is called exactly once at the beginning of the game
function love.load()
    love.window.setTitle("Lua Game")
    love.window.setMode(1200, 860)

    player = {}
    player.x = 100
    player.y = 100
    player.speed = 250
    player.gravity = 850
    player.radius = 30
    player.dx = 1
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
    player.dy = -550
end

-- callback function used to update the state of the game every frame
function love.update(dt)
    if player.x < 0 + player.radius then
        player.dx = 1
    elseif player.x > love.graphics.getWidth() - player.radius then
        player.dx = -1
    end
    player.x = player.x + player.speed * player.dx * dt
    player.dy = player.dy + 850 * dt
    player.y = player.y + player.dy * dt
end

-- callback function used to draw on the screen every frame
function love.draw()
    love.graphics.setBackgroundColor(1, 0.5, 0.5)
    love.graphics.setColor(0.5, 0.5, 1)
    love.graphics.circle("fill", player.x, player.y, player.radius)
end
