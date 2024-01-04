local rect_x = love.graphics.getWidth() / 2
local rect_y = love.graphics.getHeight() / 2
local rect_width = 48
local rect_height = 96
local back_color = {1, 0.5, 0.5}
local rect_color = {0.5, 0.5, 1}
local dx = 0

function love.load()
    love.window.setTitle("Switch Runner")
    love.window.setMode(1200, 860)
end

-- callback function triggered when a key is pressed
function love.keypressed(key, scancode, isrepeat)
    if key == "escape" then
        love.event.quit()
    end
end

-- callback function triggered when a mouse button is pressed
function love.mousepressed(x, y, button, istouch)
end

-- callback function used to update the state of the game every frame
function love.update(dt)
    rect_x = rect_x + dx * 100 * dt
end

-- callback function used to draw on the screen every frame
function love.draw()
    love.graphics.setBackgroundColor(back_color)
    love.graphics.setColor(rect_color)
    love.graphics.rectangle("fill", rect_x, rect_y, rect_width, rect_height)
end
