-- this function is called exactly once at the beginning of the game
function love.load()
    love.window.setTitle("Lua Game")
    love.window.setMode(1200, 860)

    math.randomseed(os.time())

    font1 = love.graphics.newFont("fonts/Roboto-Bold.ttf", 512)
    font2 = love.graphics.newFont("fonts/Roboto-Bold.ttf", 128)

    player = {}
    player.x = love.graphics.getWidth() / 2
    player.y = love.graphics.getHeight() / 2
    player.radius = 32
    player.velocity = 715
    player.gravity = 850
    player.dx = 0
    player.dy = -player.velocity  / 2
    player.count = 3
    player.score = 0
    player.angle = 0

    enemy = {}
    enemy.x = love.graphics.getWidth() / 2 - love.graphics.getWidth() / 4
    enemy.y = love.graphics.getHeight() / 2
    enemy.radius = 32
    enemy.velocity  = 250
    enemy.d = {-1, 1}
    enemy.dx = enemy.d[math.random(1, 2)]
    enemy.dy = enemy.d[math.random(1, 2)]

    bullet = {}
    bullet.x = math.random(300, love.graphics.getWidth() - 300)
    bullet.y = math.random(300, love.graphics.getHeight() - 300)
    bullet.radius = 16
end

-- callback function triggered when a key is pressed
function love.keypressed(key, scancode, isrepeat)
    if key == "escape" then
        love.event.quit()
    end
end

-- callback function triggered when a mouse button is pressed
function love.mousepressed(x, y, button, istouch)
    if button == 1 and player.count > 0 then
        local angle = math.atan2(y - player.y, x - player.x)
        player.dx = math.cos(angle) * -player.velocity 
        player.dy = math.sin(angle) * -player.velocity
        player.count = player.count - 1
    end
end

-- callback function used to update the state of the game every frame
function love.update(dt)
    local x, y = love.mouse.getPosition()
    player.angle = math.atan2(y - player.y, x - player.x)

    if player.x < 0 + player.radius then
        player.dx = math.abs(player.dx)
    elseif player.x > love.graphics.getWidth() - player.radius then
        player.dx = -math.abs(player.dx)
    elseif player.y > love.graphics.getHeight() + player.radius then
        player.x = love.graphics.getWidth() / 2
        player.y = love.graphics.getHeight() / 2
        player.dx = 0
        player.dy = -player.velocity  / 2
        player.count = 3
        player.score = 0

        enemy.x = love.graphics.getWidth() / 2 - love.graphics.getWidth() / 4
        enemy.y = love.graphics.getHeight() / 2    
        enemy.dx = enemy.d[math.random(1, #enemy.d)]
        enemy.dy = enemy.d[math.random(1, #enemy.d)]
    end

    player.x = player.x + player.dx * dt
    player.dy = player.dy + player.gravity * dt
    player.y = player.y + player.dy * dt

    if enemy.x < 0 + enemy.radius then
        enemy.dx = math.abs(enemy.dx)
    elseif enemy.x > love.graphics.getWidth() - enemy.radius then
        enemy.dx = -math.abs(enemy.dx)
    elseif enemy.y < 0 + enemy.radius then
        enemy.dy = math.abs(enemy.dy)
    elseif enemy.y > love.graphics.getHeight() - enemy.radius then
        enemy.dy = -math.abs(enemy.dy)
    end

    enemy.x = enemy.x + enemy.dx * enemy.velocity  * dt
    enemy.y = enemy.y + enemy.dy * enemy.velocity  * dt

    if math.sqrt((player.x - enemy.x) ^ 2 + (player.y - enemy.y) ^ 2) < player.radius + enemy.radius then
        player.x = love.graphics.getWidth() / 2
        player.y = love.graphics.getHeight() / 2
        player.dx = 0
        player.dy = -player.velocity  / 2
        player.count = 3
        player.score = 0

        enemy.x = love.graphics.getWidth() / 2 - love.graphics.getWidth() / 4
        enemy.y = love.graphics.getHeight() / 2    
        enemy.dx = -1
        enemy.dy = -1
    elseif math.sqrt((player.x - bullet.x) ^ 2 + (player.y - bullet.y) ^ 2) < player.radius + bullet.radius then
        bullet.x = math.random(300, love.graphics.getWidth() - 300)
        bullet.y = math.random(300, love.graphics.getHeight() - 300)
        player.count = player.count + 1
        player.score = player.score + 1
    end
end

-- callback function used to draw on the screen every frame
function love.draw()
    -- backgound
    love.graphics.setBackgroundColor(0.5, 0.5, 1)

    -- fonts
    love.graphics.setColor(1, 1, 1, 0.2)
    love.graphics.setFont(font1)
    love.graphics.print(player.count, love.graphics.getWidth() / 2 - font1:getWidth(player.count) / 2, love.graphics.getHeight() / 2 - font1:getHeight() / 2)
    love.graphics.setFont(font2)
    love.graphics.print(player.score, love.graphics.getWidth() / 2 - font2:getWidth(player.score) / 2, 0)

    -- player
    love.graphics.setColor(0.5, 1, 0.5)
    love.graphics.circle("fill", player.x, player.y, player.radius)

    -- player top
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("fill", player.x, player.y, player.radius - player.radius / 2)

    -- enemy
    love.graphics.setColor(1, 0.5, 0.5)
    love.graphics.circle("fill", enemy.x, enemy.y, enemy.radius)

    -- bullet
    love.graphics.setColor(1, 1, 0.5)
    love.graphics.circle("fill", bullet.x, bullet.y, bullet.radius)

    -- player barrel
    love.graphics.translate(player.x, player.y)
    love.graphics.rotate(player.angle)
    love.graphics.translate(-player.x, -player.y)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", player.x, player.y - 7, 48, 14)

    -- player barrel end
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("fill", player.x + 48, player.y, 7)
end
