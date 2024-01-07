local dir = {-1, 1}

Player = {pos_x = 0, pos_y = 0, radius = 64, velocity = 500, gravity = 600, dir_x = 0, dir_y = 0, count = 0, score = 0, angle = 0}
function Player:new(pos_x, pos_y, radius, velocity, gravity, dir_x, dir_y, count, score, angle)
    local self = setmetatable({}, Player)
    self.pos_x = pos_x
    self.pos_y = pos_y
    self.radius = radius
    self.velocity = velocity
    self.gravity = gravity
    self.dir_x = dir_x
    self.dir_y = dir_y
    self.count = count
    self.score = score
    self.angle = angle
    return self
end

Enemy = {pos_x = 0, pos_y = 0, radius = 0, velocity = 250, dir_x = 0, dir_y = 0}
function Enemy:new(pos_x, pos_y, radius, velocity, dir_x, dir_y)
    local self = setmetatable({}, Enemy)
    self.pos_x = pos_x
    self.pos_y = pos_y
    self.radius = radius
    self.velocity = velocity
    self.dir_x = dir_x
    self.dir_y = dir_y
    return self
end

Bullet = {pos_x = 0, pos_y = 0, radius = 64}
function Bullet:new(pos_x, pos_y, radius)
    local self = setmetatable({}, Bullet)
    self.pos_x = pos_x
    self.pos_y = pos_y
    self.radius = radius
    return self
end


-- this function is called exactly once at the beginning of the game
function love.load()
    love.window.setTitle("Lua Game")
    love.window.setMode(1200, 860)

    math.randomseed(os.time())

    font1 = love.graphics.newFont("fonts/Roboto-Bold.ttf", 512)
    font2 = love.graphics.newFont("fonts/Roboto-Bold.ttf", 128)

    player = Player:new(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 32, 715, 850, 0, -750 / 2, 3, 0, 0)

    enemy1 = Enemy:new(love.graphics.getWidth() / 2 - love.graphics.getWidth() / 4, love.graphics.getHeight() / 2, 32, 250, dir[math.random(1, 2)], dir[math.random(1, 2)])
    enemy2 = Enemy:new(love.graphics.getWidth() / 2 + love.graphics.getWidth() / 4, love.graphics.getHeight() / 2, 32, 250, dir[math.random(1, 2)], dir[math.random(1, 2)])

    bullet1 = Bullet:new(math.random(300, love.graphics.getWidth() - 300), math.random(300, love.graphics.getHeight() - 300), 16)
    bullet2 = Bullet:new(math.random(300, love.graphics.getWidth() - 300), math.random(300, love.graphics.getHeight() - 300), 16)
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
        local angle = math.atan2(y - player.pos_y, x - player.pos_x)
        player.dir_x = math.cos(angle) * -player.velocity 
        player.dir_y = math.sin(angle) * -player.velocity
        player.count = player.count - 1
    end
end

-- callback function used to update the state of the game every frame
function love.update(dt)
    local x, y = love.mouse.getPosition()
    player.angle = math.atan2(y - player.pos_y, x - player.pos_x)

    if player.pos_x < 0 + player.radius then
        player.dir_x = math.abs(player.dir_x)
    elseif player.pos_x > love.graphics.getWidth() - player.radius then
        player.dir_x = -math.abs(player.dir_x)
    elseif player.pos_y > love.graphics.getHeight() + player.radius then
        player.pos_x = love.graphics.getWidth() / 2
        player.pos_y = love.graphics.getHeight() / 2
        player.dir_x = 0
        player.dir_y = -player.velocity  / 2
        player.count = 3
        player.score = 0

        enemy1.pos_x = love.graphics.getWidth() / 2 - love.graphics.getWidth() / 4
        enemy1.pos_y = love.graphics.getHeight() / 2    
        enemy1.dir_x = dir[math.random(1, #dir)]
        enemy1.dir_y = dir[math.random(1, #dir)]

        enemy2.pos_x = love.graphics.getWidth() / 2 + love.graphics.getWidth() / 4
        enemy2.pos_y = love.graphics.getHeight() / 2    
        enemy2.dir_x = dir[math.random(1, #dir)]
        enemy2.dir_y = dir[math.random(1, #dir)]
    end

    player.pos_x = player.pos_x + player.dir_x * dt
    player.dir_y = player.dir_y + player.gravity * dt
    player.pos_y = player.pos_y + player.dir_y * dt

    if enemy1.pos_x < 0 + enemy1.radius then
        enemy1.dir_x = math.abs(enemy1.dir_x)
    elseif enemy1.pos_x > love.graphics.getWidth() - enemy1.radius then
        enemy1.dir_x = -math.abs(enemy1.dir_x)
    elseif enemy1.pos_y < 0 + enemy1.radius then
        enemy1.dir_y = math.abs(enemy1.dir_y)
    elseif enemy1.pos_y > love.graphics.getHeight() - enemy1.radius then
        enemy1.dir_y = -math.abs(enemy1.dir_y)
    end

    if enemy2.pos_x < 0 + enemy2.radius then
        enemy2.dir_x = math.abs(enemy2.dir_x)
    elseif enemy2.pos_x > love.graphics.getWidth() - enemy2.radius then
        enemy2.dir_x = -math.abs(enemy2.dir_x)
    elseif enemy2.pos_y < 0 + enemy2.radius then
        enemy2.dir_y = math.abs(enemy2.dir_y)
    elseif enemy2.pos_y > love.graphics.getHeight() - enemy2.radius then
        enemy2.dir_y = -math.abs(enemy2.dir_y)
    end

    enemy1.pos_x = enemy1.pos_x + enemy1.dir_x * enemy1.velocity  * dt
    enemy1.pos_y = enemy1.pos_y + enemy1.dir_y * enemy1.velocity  * dt

    enemy2.pos_x = enemy2.pos_x + enemy2.dir_x * enemy2.velocity  * dt
    enemy2.pos_y = enemy2.pos_y + enemy2.dir_y * enemy2.velocity  * dt

    if math.sqrt((player.pos_x - enemy1.pos_x) ^ 2 + (player.pos_y - enemy1.pos_y) ^ 2) < player.radius + enemy1.radius then
        player.pos_x = love.graphics.getWidth() / 2
        player.pos_y = love.graphics.getHeight() / 2
        player.dir_x = 0
        player.dir_y = -player.velocity  / 2
        player.count = 3
        player.score = 0

        enemy1.pos_x = love.graphics.getWidth() / 2 - love.graphics.getWidth() / 4
        enemy1.pos_y = love.graphics.getHeight() / 2    
        enemy1.dir_x = -1
        enemy1.dir_y = -1

        enemy2.pos_x = love.graphics.getWidth() / 2 + love.graphics.getWidth() / 4
        enemy2.pos_y = love.graphics.getHeight() / 2    
        enemy2.dir_x = -1
        enemy2.dir_y = -1
    elseif math.sqrt((player.pos_x - enemy2.pos_x) ^ 2 + (player.pos_y - enemy2.pos_y) ^ 2) < player.radius + enemy2.radius then
        player.pos_x = love.graphics.getWidth() / 2
        player.pos_y = love.graphics.getHeight() / 2
        player.dir_x = 0
        player.dir_y = -player.velocity  / 2
        player.count = 3
        player.score = 0

        enemy1.pos_x = love.graphics.getWidth() / 2 - love.graphics.getWidth() / 4
        enemy1.pos_y = love.graphics.getHeight() / 2    
        enemy1.dir_x = -1
        enemy1.dir_y = -1

        enemy2.pos_x = love.graphics.getWidth() / 2 + love.graphics.getWidth() / 4
        enemy2.pos_y = love.graphics.getHeight() / 2    
        enemy2.dir_x = -1
        enemy2.dir_y = -1
    elseif math.sqrt((player.pos_x - bullet1.pos_x) ^ 2 + (player.pos_y - bullet1.pos_y) ^ 2) < player.radius + bullet1.radius then
        bullet1.pos_x = math.random(300, love.graphics.getWidth() - 300)
        bullet1.pos_y = math.random(300, love.graphics.getHeight() - 300)
        player.count = player.count + 1
        player.score = player.score + 1
    elseif math.sqrt((player.pos_x - bullet2.pos_x) ^ 2 + (player.pos_y - bullet2.pos_y) ^ 2) < player.radius + bullet2.radius then
        bullet2.pos_x = math.random(300, love.graphics.getWidth() - 300)
        bullet2.pos_y = math.random(300, love.graphics.getHeight() - 300)
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
    love.graphics.circle("fill", player.pos_x, player.pos_y, player.radius)

    -- player top
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("fill", player.pos_x, player.pos_y, player.radius - player.radius / 2)

    -- enemy1
    love.graphics.setColor(1, 0.5, 0.5)
    love.graphics.circle("fill", enemy1.pos_x, enemy1.pos_y, enemy1.radius)
    -- enemy2
    love.graphics.setColor(1, 0.5, 0.5)
    love.graphics.circle("fill", enemy2.pos_x, enemy2.pos_y, enemy2.radius)

    -- bullet1
    love.graphics.setColor(1, 1, 0.5)
    love.graphics.circle("fill", bullet1.pos_x, bullet1.pos_y, bullet1.radius)

    -- bullet2
    love.graphics.setColor(1, 1, 0.5)
    love.graphics.circle("fill", bullet2.pos_x, bullet2.pos_y, bullet2.radius)

    -- player barrel
    love.graphics.translate(player.pos_x, player.pos_y)
    love.graphics.rotate(player.angle)
    love.graphics.translate(-player.pos_x, -player.pos_y)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", player.pos_x, player.pos_y - 7, 48, 14)

    -- player barrel end
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("fill", player.pos_x + 48, player.pos_y, 7)
end
