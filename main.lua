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

    enemy1 = {}
    enemy1.x = love.graphics.getWidth() / 2 - love.graphics.getWidth() / 4
    enemy1.y = love.graphics.getHeight() / 2
    enemy1.radius = 32
    enemy1.velocity  = 250
    enemy1.d = {-1, 1}
    enemy1.dx = enemy1.d[math.random(1, 2)]
    enemy1.dy = enemy1.d[math.random(1, 2)]

    enemy2 = {}
    enemy2.x = love.graphics.getWidth() / 2 + love.graphics.getWidth() / 4
    enemy2.y = love.graphics.getHeight() / 2
    enemy2.radius = 32
    enemy2.velocity  = 250
    enemy2.d = {-1, 1}
    enemy2.dx = enemy2.d[math.random(1, 2)]
    enemy2.dy = enemy2.d[math.random(1, 2)]

    bullet1 = {}
    bullet1.x = math.random(300, love.graphics.getWidth() - 300)
    bullet1.y = math.random(300, love.graphics.getHeight() - 300)
    bullet1.radius = 16

    bullet2 = {}
    bullet2.x = math.random(300, love.graphics.getWidth() - 300)
    bullet2.y = math.random(300, love.graphics.getHeight() - 300)
    bullet2.radius = 16
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

        enemy1.x = love.graphics.getWidth() / 2 - love.graphics.getWidth() / 4
        enemy1.y = love.graphics.getHeight() / 2    
        enemy1.dx = enemy1.d[math.random(1, #enemy1.d)]
        enemy1.dy = enemy1.d[math.random(1, #enemy1.d)]

        enemy2.x = love.graphics.getWidth() / 2 + love.graphics.getWidth() / 4
        enemy2.y = love.graphics.getHeight() / 2    
        enemy2.dx = enemy2.d[math.random(1, #enemy2.d)]
        enemy2.dy = enemy2.d[math.random(1, #enemy2.d)]
    end

    player.x = player.x + player.dx * dt
    player.dy = player.dy + player.gravity * dt
    player.y = player.y + player.dy * dt

    if enemy1.x < 0 + enemy1.radius then
        enemy1.dx = math.abs(enemy1.dx)
    elseif enemy1.x > love.graphics.getWidth() - enemy1.radius then
        enemy1.dx = -math.abs(enemy1.dx)
    elseif enemy1.y < 0 + enemy1.radius then
        enemy1.dy = math.abs(enemy1.dy)
    elseif enemy1.y > love.graphics.getHeight() - enemy1.radius then
        enemy1.dy = -math.abs(enemy1.dy)
    end

    if enemy2.x < 0 + enemy2.radius then
        enemy2.dx = math.abs(enemy2.dx)
    elseif enemy2.x > love.graphics.getWidth() - enemy2.radius then
        enemy2.dx = -math.abs(enemy2.dx)
    elseif enemy2.y < 0 + enemy2.radius then
        enemy2.dy = math.abs(enemy2.dy)
    elseif enemy2.y > love.graphics.getHeight() - enemy2.radius then
        enemy2.dy = -math.abs(enemy2.dy)
    end

    enemy1.x = enemy1.x + enemy1.dx * enemy1.velocity  * dt
    enemy1.y = enemy1.y + enemy1.dy * enemy1.velocity  * dt

    enemy2.x = enemy2.x + enemy2.dx * enemy2.velocity  * dt
    enemy2.y = enemy2.y + enemy2.dy * enemy2.velocity  * dt

    if math.sqrt((player.x - enemy1.x) ^ 2 + (player.y - enemy1.y) ^ 2) < player.radius + enemy1.radius then
        player.x = love.graphics.getWidth() / 2
        player.y = love.graphics.getHeight() / 2
        player.dx = 0
        player.dy = -player.velocity  / 2
        player.count = 3
        player.score = 0

        enemy1.x = love.graphics.getWidth() / 2 - love.graphics.getWidth() / 4
        enemy1.y = love.graphics.getHeight() / 2    
        enemy1.dx = -1
        enemy1.dy = -1

        enemy2.x = love.graphics.getWidth() / 2 + love.graphics.getWidth() / 4
        enemy2.y = love.graphics.getHeight() / 2    
        enemy2.dx = -1
        enemy2.dy = -1
    elseif math.sqrt((player.x - enemy2.x) ^ 2 + (player.y - enemy2.y) ^ 2) < player.radius + enemy2.radius then
        player.x = love.graphics.getWidth() / 2
        player.y = love.graphics.getHeight() / 2
        player.dx = 0
        player.dy = -player.velocity  / 2
        player.count = 3
        player.score = 0

        enemy1.x = love.graphics.getWidth() / 2 - love.graphics.getWidth() / 4
        enemy1.y = love.graphics.getHeight() / 2    
        enemy1.dx = -1
        enemy1.dy = -1

        enemy2.x = love.graphics.getWidth() / 2 + love.graphics.getWidth() / 4
        enemy2.y = love.graphics.getHeight() / 2    
        enemy2.dx = -1
        enemy2.dy = -1
    elseif math.sqrt((player.x - bullet1.x) ^ 2 + (player.y - bullet1.y) ^ 2) < player.radius + bullet1.radius then
        bullet1.x = math.random(300, love.graphics.getWidth() - 300)
        bullet1.y = math.random(300, love.graphics.getHeight() - 300)
        player.count = player.count + 1
        player.score = player.score + 1
    elseif math.sqrt((player.x - bullet2.x) ^ 2 + (player.y - bullet2.y) ^ 2) < player.radius + bullet2.radius then
        bullet2.x = math.random(300, love.graphics.getWidth() - 300)
        bullet2.y = math.random(300, love.graphics.getHeight() - 300)
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

    -- enemy1
    love.graphics.setColor(1, 0.5, 0.5)
    love.graphics.circle("fill", enemy1.x, enemy1.y, enemy1.radius)
    -- enemy2
    love.graphics.setColor(1, 0.5, 0.5)
    love.graphics.circle("fill", enemy2.x, enemy2.y, enemy2.radius)

    -- bullet1
    love.graphics.setColor(1, 1, 0.5)
    love.graphics.circle("fill", bullet1.x, bullet1.y, bullet1.radius)

    -- bullet2
    love.graphics.setColor(1, 1, 0.5)
    love.graphics.circle("fill", bullet2.x, bullet2.y, bullet2.radius)

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
