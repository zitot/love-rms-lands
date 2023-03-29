local isDragging = false
local startX, startY

function love.mousepressed(x, y, button)
    if button == 1 then -- left mouse button
        isDragging = true
        startX, startY = x, y
        print("lmouse pressed")
    end
end

function love.mousereleased(x, y, button)
    if button == 1 then -- left mouse button
        isDragging = false
        print("lmouse released")
    end
end

function love.mousemoved(x, y, dx, dy)
    if isDragging then
        -- mouse is being dragged
        -- do something with dx and dy
        print("mouse moved")
    end
end

function love.touchpressed(id, x, y)
    isDragging = true
    startX, startY = x, y
    print("touch pressed")

end

function love.touchreleased(id, x, y)
    isDragging = false
    print("touch released")
end

function love.touchmoved(id, x, y, dx, dy)
    if isDragging then
        -- touch is being dragged
        -- do something with dx and dy
        print("touch moved")
    end
end

function love.conf(t)
    t.console = true
    t.modules.joystick = false
    t.modules.physics = false
end