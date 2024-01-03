local window_x = 0
local window_y = 0
local rect_width = 0
local rect_height = 0
local timer = 0
local back_color = {1, 0.5, 0.5}
local rect_color = {0.5, 0.5, 1}
local back_switch = true
local rect_switch = true

-- callback function triggered when a key is pressed
function love.keypressed(key)
    if key == "escape" then
        love.event.push("quit")
    end
end

-- callback function triggered when a mouse button is pressed
function love.mousepressed(x, y, button, istouch)
    if button == 1 then
        if rect_switch then
            rect_color = {0.5, 0.5, 1}
        else
            rect_color = {1, 0.5, 0.5}
        end
        rect_switch = not rect_switch
    end
 end

-- callback function used to update the state of the game every frame
function love.update(dt)
    if timer <= 0 then
        rect_width = math.random(50, 200)
        rect_height = math.random(50, 200)
        window_x = love.graphics.getWidth() / 2 - rect_width / 2
        window_y = love.graphics.getHeight() / 2 - rect_height / 2
        if back_switch then
            back_color = {1, 0.5, 0.5}
        else
            back_color = {0.5, 0.5, 1}
        end
        back_switch = not back_switch
        timer = 1
    else
        timer = timer - dt
    end
end

-- callback function used to draw on the screen every frame
function love.draw()
    love.graphics.setBackgroundColor(back_color)
    love.graphics.setColor(rect_color)
    love.graphics.rectangle("fill", window_x, window_y, rect_width, rect_height)
end
