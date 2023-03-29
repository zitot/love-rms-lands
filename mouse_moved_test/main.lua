local isDragging = false
local startX, startY

function love.mousepressed(x, y, button)
    if button == 1 then -- left mouse button
        isDragging = true
        startX, startY = x, y
    end
end

function love.mousereleased(x, y, button)
    if button == 1 then -- left mouse button
        isDragging = false
    end
end

function love.mousemoved(x, y, dx, dy)
    if isDragging then
        -- mouse is being dragged
        -- do something with dx and dy
    end
end

function love.touchpressed(id, x, y)
    isDragging = true
    startX, startY = x, y
end

function love.touchreleased(id, x, y)
    isDragging = false
end

function love.touchmoved(id, x, y, dx, dy)
    if isDragging then
        -- touch is being dragged
        -- do something with dx and dy
    end
end
