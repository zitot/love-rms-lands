love.window.setTitle( "rms paint mockup 1.1")

local mainmap = require "mainmap"
local ui = require "ui"
local terrain = require "terrain"

-- todo: map.lua
local MAPSIZE = 36 -- size of the map
-- local tiles = {} -- table to store the tiles
-- local tileSize = 32 -- size of each tile in pixels
-- local angle = math.rad(-45) -- angle to rotate the map

-- todo: brush.lua
local base_terrain = "GRASS"
local brush_terrain_type = "ICE"
local brush_base_size = 1

local brush_sizes = {
    "3x3", "5x5", "7x7", "none"
}

-- todo: move to map.lua
-- initialize the tiles
--[[for i = 1, MAPSIZE do
    tiles[i] = {}
    for j = 1, MAPSIZE do
        tiles[i][j] = {terrain_type = "GRASS"}
    end
end

tiles[1][1] = {terrain_type = "DIRT"}
tiles[1][2] = {terrain_type = "GRASS"}
tiles[1][3] = {terrain_type = "GRASS2"}
tiles[1][4] = {terrain_type = "GRASS3"}
tiles[1][5] = {terrain_type = "DIRT"}
tiles[1][6] = {terrain_type = "DIRT2"}
tiles[1][7] = {terrain_type = "DIRT3"}
tiles[1][8] = {terrain_type = "WATER"}
tiles[1][9] = {terrain_type = "MED_WATER"}
tiles[1][10] = {terrain_type = "DEEP_WATER"}
tiles[2][1] = {terrain_type = "SHALLOW"}
tiles[2][2] = {terrain_type = "FOREST"}
tiles[2][3] = {terrain_type = "JUNGLE"}
tiles[2][4] = {terrain_type = "ICE"}
tiles[2][5] = {terrain_type = "SNOW"}
tiles[2][6] = {terrain_type = "BEACH"}
--]]
function love.conf(t)
    t.console = true
    t.window.width = 2048
    t.window.height = 768
    t.modules.joystick = false
    t.modules.physics = false

end

-- todo: get grid working in mainmap.lua
-- local grid_state = "dashed" -- off, dashed, dotted, solid
-- local cameraX = 0
-- local cameraY = 0
-- local cameraSpeed = 1000 -- pixels per second

-- local canvas = love.graphics.newCanvas()

local function drawDashedLine(x1, y1, x2, y2, dashLength, gapLength)
    local dx = x2 - x1
    local dy = y2 - y1
    local length = math.sqrt(dx * dx + dy * dy)
    local dirX = dx / length
    local dirY = dy / length

    local dashCount = math.floor(length / (dashLength + gapLength))
    for i = 0, dashCount do
        local startX = x1 + dirX * (i * (dashLength + gapLength))
        local startY = y1 + dirY * (i * (dashLength + gapLength))
        local endX = startX + dirX * dashLength
        local endY = startY + dirY * dashLength
        love.graphics.line(startX, startY, endX, endY)
    end
end


local function paintTile(row,col)
    -- paint the tile at row,col
    -- will overwrite neighboring tiles
    neighbors = MAPSIZE --TODO: ?
end

-- local function getTileAtCursor(x, y, button)
--     local x = x - cameraX
--     local y = y - cameraY
--     local c = math.cos(-angle)
--     local s = math.sin(-angle)

--     x, y = c * x - s * y, s * x + c * y

--     -- 
--     local i = math.floor(x / tileSize + MAPSIZE / 2) 
--     local j = math.floor(y / tileSize + MAPSIZE / 2) 

--     -- if i >= 1 and i <= MAPSIZE and j >= 1 and j <= MAPSIZE then
--     --     special_text_to_draw_in_top_right_corner = tiles[i][j].terrain_type ..
--     --      "\nx:" .. i .. "\ny:" .. j 
--     --     -- tiles[i][j].substring = string.char(math.random(65, 90))
--     -- end
--     if i >= 1 and i <= MAPSIZE and j >= 1 and j <= MAPSIZE then
--         return i, j
--     end
-- end

-- local isDragging = false
-- local startX, startY

-- function to handle touches and clicks
-- local function handleTouch(x, y)
--     -- x = x - love.graphics.getWidth() / 2
--     -- y = y - love.graphics.getHeight() / 2

--     local x = x - cameraX
--     local y = y - cameraY



--     local c = math.cos(-angle)
--     local s = math.sin(-angle)

--     x, y = c * x - s * y, s * x + c * y

--     -- 
--     local i = math.floor(x / tileSize + MAPSIZE / 2) 
--     local j = math.floor(y / tileSize + MAPSIZE / 2) 

--     if i >= 1 and i <= MAPSIZE and j >= 1 and j <= MAPSIZE then
--         -- special_text_to_draw_in_top_left_corner = tiles[i][j].terrain_type ..
--          -- "\nx:" .. i .. "\ny:" .. j 
--          ui.lines[1].substring = "tile: "..tiles[i][j].terrain_type
--          ui.lines[2].substring = "x:" .. i .. " y: " .. j
--         -- tiles[i][j].substring = string.char(math.random(65, 90))
--     end
-- end



-- Love2D callbacks
function love.draw()
    -- local major, minor, revision, codename = love.getVersion()
    -- local str = string.format("Version %d.%d.%d - %s", major, minor, revision, codename)
    -- love.graphics.setColor(0, 1, 0)
    -- love.graphics.print(str, 500, 20)
    love.graphics.setColor(1,1,1)
    love.graphics.draw(mainmap.canvas) -- draw canvas onto screen

    -- drawUI
    if not ui.ishidden then
        ui.draw()
    end

end
-- love.graphics.rectangle( mode, x, y, width, height, rx, ry, segments )
-- Arguments
-- DrawMode mode ("fill" or "line")
-- How to draw the rectangle.
-- number x
-- The position of top-left corner along the x-axis.
-- number y
-- The position of top-left corner along the y-axis.
-- number width
-- Width of the rectangle.
-- number height
-- Height of the rectangle.
-- Available since LÖVE 0.10.0
-- number rx (nil)
-- The x-axis radius of each round corner. Cannot be greater than half the rectangle's width.
-- number ry (rx)
-- The y-axis radius of each round corner. Cannot be greater than half the rectangle's height.
-- number segments (nil)
-- The number of segments used for drawing the round corners. A default amount will be chosen if no number is given.
-- 

-- mouse functions
function love.mousepressed(x, y, button)
    -- handleTouch(x, y)
    -- if button == 1 then -- left mouse button
    --     isDragging = true
    --     startX, startY = x, y
    --     print("lmouse pressed")
    -- end
    mainmap:mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
    -- if button == 1 then -- left mouse button
    --     isDragging = false
    --     print("lmouse released")
    -- end
    mainmap:mousereleased(x, y, button)
end

function love.mousemoved(x, y, dx, dy)
    if isDragging then
        local x, y = getTileAtCursor(x, y)
        -- mouse is being dragged
        -- do something with dx and dy
        if x and y then
            print("mouse moved " .. x .. ", " .. y)
        end
    end
    mainmap:mousemoved(x, y, button)
end

-- todo: handle touches
-- note: i am extremely unlikely to ever use touch interface in love2d with my iphone
-- function love.touchpressed(id, x, y)
--     handleTouch(x, y)

--     isDragging = true
--     startX, startY = x, y
--     print("touch pressed")

-- end

-- function love.touchreleased(id, x, y)
--     isDragging = false
--     print("touch released")
-- end

-- function love.touchmoved(id, x, y, dx, dy)
--     if isDragging then
--         -- touch is being dragged
--         -- do something with dx and dy
--         print("touch moved")
--     end
-- end

function love.update(dt)
    mainmap:update(dt)
end



function love.load()
    ui.setMapSize(MAPSIZE)
    mainmap:init(MAPSIZE)
    mainmap:draw() -- draw map onto screen
end
