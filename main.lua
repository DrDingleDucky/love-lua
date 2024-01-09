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

Refill = {pos_x = 0, pos_y = 0, radius = 64}
function Refill:new(pos_x, pos_y, radius)
    local self = setmetatable({}, Refill)
    self.pos_x = pos_x
    self.pos_y = pos_y
    self.radius = radius
    return self
end

Bullet = {pos_x = 0, pos_y = 0, radius = 64, velocity = 250, dir_x = 0, dir_y = 0}
function Bullet:new(pos_x, pos_y, radius, velocity, dir_x, dir_y)
    local self = setmetatable({}, Bullet)
    self.pos_x = pos_x
    self.pos_y = pos_y
    self.radius = radius
    self.velocity = velocity
    self.dir_x = dir_x
    self.dir_y = dir_y
    return self
end

function reset()
    enemies = {
        Enemy:new(love.graphics.getWidth() / 2 - love.graphics.getWidth() / 4, love.graphics.getHeight() / 2, 32, 200, dir[math.random(1, 2)], dir[math.random(1, 2)]),
        Enemy:new(love.graphics.getWidth() / 2 + love.graphics.getWidth() / 4, love.graphics.getHeight() / 2, 32, 200, dir[math.random(1, 2)], dir[math.random(1, 2)])
    }

    player.pos_x = love.graphics.getWidth() / 2
    player.pos_y = love.graphics.getHeight() / 2
    player.dir_x = 0
    player.dir_y = -player.velocity  / 2
    player.count = 3
    player.score = 0

    for key, value in pairs(enemies) do
        value.pos_y = love.graphics.getHeight() / 2
        value.dir_x = dir[math.random(1, #dir)]
        value.dir_y = dir[math.random(1, #dir)]
        value.pos_x = love.graphics.getWidth() / 2 + love.graphics.getWidth() / 4 * dir[key]
    end 

    for key, value in pairs(refills) do
        value.pos_x = math.random(300, love.graphics.getWidth() - 300)
        value.pos_y = math.random(300, love.graphics.getHeight() - 300)    
    end
end

function love.load()
    math.randomseed(os.time())

    love.window.setTitle("Lua Game")
    love.window.setMode(1200, 860)

    font1 = love.graphics.newFont("fonts/Roboto-Bold.ttf", 512)
    font2 = love.graphics.newFont("fonts/Roboto-Bold.ttf", 128)

    player = Player:new(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 32, 715, 850, 0, -750 / 2, 3, 0, 0)

    enemies = {
        Enemy:new(love.graphics.getWidth() / 2 - love.graphics.getWidth() / 4, love.graphics.getHeight() / 2, 32, 200, dir[math.random(1, 2)], dir[math.random(1, 2)]),
        Enemy:new(love.graphics.getWidth() / 2 + love.graphics.getWidth() / 4, love.graphics.getHeight() / 2, 32, 200, dir[math.random(1, 2)], dir[math.random(1, 2)])
    }

    refills = {
        Refill:new(math.random(300, love.graphics.getWidth() - 300), math.random(300, love.graphics.getHeight() - 300), 16),
        Refill:new(math.random(300, love.graphics.getWidth() - 300), math.random(300, love.graphics.getHeight() - 300), 16)
    }

    bullets = {}
end

function love.keypressed(key, scancode, isrepeat)
    if key == "escape" then
        love.event.quit()
    end
end

function love.mousepressed(x, y, button, istouch)
    if button == 1 and player.count > 0 then
        local angle = math.atan2(y - player.pos_y, x - player.pos_x)
        player.dir_x = math.cos(angle) * -player.velocity 
        player.dir_y = math.sin(angle) * -player.velocity
        player.count = player.count - 1
        table.insert(bullets, Bullet:new(player.pos_x, player.pos_y, 14, 800, math.cos(angle), math.sin(angle)))
    end
end

function love.update(dt)
    local x, y = love.mouse.getPosition()
    player.angle = math.atan2(y - player.pos_y, x - player.pos_x)

    if player.pos_x < 0 + player.radius then
        player.dir_x = math.abs(player.dir_x)
    elseif player.pos_x > love.graphics.getWidth() - player.radius then
        player.dir_x = -math.abs(player.dir_x)
    elseif player.pos_y > love.graphics.getHeight() + player.radius then
        reset()
    end

    player.pos_x = player.pos_x + player.dir_x * dt
    player.dir_y = player.dir_y + player.gravity * dt
    player.pos_y = player.pos_y + player.dir_y * dt

    for key, value in pairs(enemies) do
        if value.pos_x < value.radius then
            value.dir_x = math.abs(value.dir_x)
        elseif value.pos_x > love.graphics.getWidth() - value.radius then
            value.dir_x = -math.abs(value.dir_x)
        elseif value.pos_y < value.radius then
            value.dir_y = math.abs(value.dir_y)
        elseif value.pos_y > love.graphics.getHeight() - value.radius then
            value.dir_y = -math.abs(value.dir_y)
        end

        if math.sqrt((player.pos_x - value.pos_x) ^ 2 + (player.pos_y - value.pos_y) ^ 2) < player.radius + value.radius then
            reset()
        end
        value.pos_x = value.pos_x + value.dir_x * value.velocity  * dt
        value.pos_y = value.pos_y + value.dir_y * value.velocity  * dt
    end

    for key, value in pairs(refills) do
        if math.sqrt((player.pos_x - value.pos_x) ^ 2 + (player.pos_y - value.pos_y) ^ 2) < player.radius + value.radius then
            value.pos_x = math.random(300, love.graphics.getWidth() - 300)
            value.pos_y = math.random(300, love.graphics.getHeight() - 300)
            player.count = player.count + 1
            player.score = player.score + 1
        end
    end

    for key1, value1 in pairs(bullets) do
        for key2, value2 in pairs(enemies) do
            if math.sqrt((value2.pos_x - value1.pos_x) ^ 2 + (value2.pos_y - value1.pos_y) ^ 2) < value2.radius + value1.radius then
                value2.pos_y = -value2.radius - 1300
            end
        end
        value1.pos_x = value1.pos_x + value1.dir_x * value1.velocity * dt
        value1.pos_y = value1.pos_y + value1.dir_y * value1.velocity * dt
    end
end

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

    -- enemies
    love.graphics.setColor(1, 0.5, 0.5)
    for key, value in pairs(enemies) do
        love.graphics.circle("fill", value.pos_x, value.pos_y, value.radius)
    end

    -- refill1
    love.graphics.setColor(1, 1, 0.5)
    for key, value in pairs(refills) do
        love.graphics.circle("fill", value.pos_x, value.pos_y, value.radius)
    end    

    love.graphics.setColor(1, 1, 0.5)
    for key, value in pairs(bullets) do
        love.graphics.circle("fill", value.pos_x, value.pos_y, value.radius)
    end

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
