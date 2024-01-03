local window_x = 0
local window_y = 0
local rect_width = 20
local rect_height = 20
local timer = 0

-- callback function triggered when a key is pressed
function love.keypressed(key)
    if key == "escape" then
        love.event.push("quit")        
    end
end

-- callback function used to update the state of the game every frame
function love.update(dt)
    if timer <= 0 then
        rect_width = math.random(50, 200)
        rect_height = math.random(50, 200)
        window_x = love.graphics.getWidth() / 2 - rect_width / 2
        window_y = love.graphics.getHeight() / 2 - rect_height / 2
        timer = 1
    else
        timer = timer - dt
    end
end
    
-- callback function used to draw on the screen every frame
function love.draw()
    love.graphics.setColor(1, 0.4, 0.4)
    love.graphics.rectangle("fill", window_x, window_y, rect_width, rect_height)
end
