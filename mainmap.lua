local ui = require "ui"

local map = {}
local terrain = require "terrain"
local tiles = {} -- table to store the tiles
local tileSize = 32 -- size of each tile in pixels
local angle = math.rad(-45) -- angle to rotate the map
local cameraX = 0
local cameraY = 0
local cameraSpeed = 1000  --pixels per second
map.canvas = love.graphics.newCanvas()


-- override_map_size in RMS has one argument: an integer between 36 and 480
function map:init(mapsize)
	-- assert(type(mapsize) == "number" and math.type(mapsize) == "integer" and mapsize >= 36 and mapsize <= 480)
	print(type(mapsize))
	self.mapsize = mapsize

	-- initialize the tiles
	for i = 1, mapsize do
	    tiles[i] = {}
	    for j = 1, mapsize do
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

end


function map:draw()
    love.graphics.setCanvas(self.canvas) -- set canvas as active drawing target
    love.graphics.clear() -- clear the canvas (if there is no canvas, this would clear the screen)

    -- perform drawing operations here
    love.graphics.push()
    -- NOTE: why am I translating to the camera now?? Doesn't this belong in love.draw()??
    love.graphics.translate(cameraX, cameraY)
    love.graphics.rotate(angle)

    -- love.graphics.setLineWidth(2) -- set line width to 5 pixels
    for i = 1, self.mapsize do
        for j = 1, self.mapsize do
            -- NOTE: why am i subtracting mapsize / 2 from i? I don't recall, not at all
            -- if i want to fix that i need to also change love.mousepressed
            local x = (i - self.mapsize / 2) * tileSize
            local y = (j - self.mapsize / 2) * tileSize

            -- FIXME: Cannot use x = i*tileSize without screwing up touch coordinates
            -- local x = i * tileSize
            -- local y = j * tileSize
            local terrain_type =  tiles[i][j].terrain_type
            -- draw minimap
            -- love.graphics.setColor(MINIMAP_TERRAIN_COLORS[terrain_type])
            -- love.graphics.rectangle("fill", x, y, tileSize, tileSize) 

            -- draw main view of map (with sprites and stuff)
            -- The origin is by default located at the top left corner of Image and Canvas objects
            love.graphics.setColor(1,1,1)
            local sprite = terrain.sprites[terrain_type]
            love.graphics.draw(sprite, x, y)
        end
    end

    -- FIXME: Grid wont draw correctly
    --[[
    --draw top border
    local x = 1 - MAPSIZE / 2 * tileSize
    local endX = x + tileSize
    local y = 0
    love.graphics.setColor(1,0,0)
    love.graphics.line(x, y, endX, y) 

    local x = 2 - MAPSIZE / 2 * tileSize
    local endX = x + tileSize
    local y = 1 * tileSize
    love.graphics.setColor(1,1,0)
    love.graphics.line(x, y, endX, y) 

    -- draw grid
    local x = -20
    local x2 = tileSize * MAPSIZE
    local y2 = tileSize * MAPSIZE
    love.graphics.setColor(1, 0.5, 0.5)

    -- love.graphics.translate()
    -- draw MAPSIZE rows (probably 1-0-0)
    for row = 1, MAPSIZE do
        if grid_state == "dashed" then
            local y = tileSize * row
            love.graphics.line(x, y, x2, y)
            -- drawDashedLine(x, y, x2, y, 4, 2)
        elseif grid_state == "dotted" then

        elseif grid_state == "solid" then

        elseif grid_state == "none" then

        end

    end
    --]]



    love.graphics.pop()
    love.graphics.setCanvas() -- reset active drawing target to screen
end

function map:getTileAtCursor(x, y, button)
    local x = x - cameraX
    local y = y - cameraY
    local c = math.cos(-angle)
    local s = math.sin(-angle)

    x, y = c * x - s * y, s * x + c * y

    -- 
    local i = math.floor(x / tileSize + self.mapsize / 2) 
    local j = math.floor(y / tileSize + self.mapsize / 2) 

    if i >= 1 and i <= self.mapsize and j >= 1 and j <= self.mapsize then
        return i, j
    end
end

local isDragging = false
local startX, startY

-- function to handle touches and clicks
function map:handleTouch(x, y)
    local x = x - cameraX
    local y = y - cameraY
    local c = math.cos(-angle)
    local s = math.sin(-angle)

    x, y = c * x - s * y, s * x + c * y

    local i = math.floor(x / tileSize + self.mapsize / 2) 
    local j = math.floor(y / tileSize + self.mapsize / 2) 

    if i >= 1 and i <= self.mapsize and j >= 1 and j <= self.mapsize then
         ui.lines[1].substring = "tile: "..tiles[i][j].terrain_type
         ui.lines[2].substring = "x:" .. i .. " y: " .. j
    else
         ui.lines[1].substring = "tile: "
         ui.lines[2].substring = "x:   y: "
     end
end

function map:mousepressed(x, y, button)
	self:handleTouch(x,y)
    if button == 1 then -- left mouse button
    	local x, y = self:getTileAtCursor(x, y)
        isDragging = true
        -- startX, startY = x, y
        -- print("lmouse pressed (mousepressed in mainmap.lua)")
        if x and y then print("mouse pressed " .. x .. ", " .. y, "(mousepressed in mainmap.lua)") end
    end
end

function map:mousereleased(x, y, button)
	self:handleTouch(x,y)
    if button == 1 then -- left mouse button
    	local x, y = self:getTileAtCursor(x, y)
        isDragging = false
        -- print("lmouse released (mousereleased in mainmap.lua)")
        if x and y then print("mouse released " .. x .. ", " .. y, "(mousereleased in mainmap.lua)") end
    end
end

function map:mousemoved(x, y, dx, dy)
	self:handleTouch(x,y)
    if isDragging then
        local x, y = self:getTileAtCursor(x, y)
        -- mouse is being dragged
        -- do something with dx and dy
        if x and y then
            print("mouse moved " .. x .. ", " .. y, "(mousemoved in mainmap.lua)")
        end
    end
end


function map:update(dt)
    if love.keyboard.isDown("left") then
        cameraX = math.floor(cameraX + cameraSpeed * dt)
        -- we use math.floor because otherwise text ui elements will be blurry
        self:draw() -- todo: I should not be redrawing the map each frame
                    --       the fix is to decouple the translation of the camera from the drawing of the map
    elseif love.keyboard.isDown("right") then
        cameraX = math.floor(cameraX - cameraSpeed * dt)
        -- we use math.floor because otherwise text ui elements will be blurry
        self:draw()
    end

    if love.keyboard.isDown("up") then
        -- print("up")
        cameraY = math.floor(cameraY + cameraSpeed * dt)
        -- we use math.floor because otherwise text ui elements will be blurry
        self:draw()
    elseif love.keyboard.isDown("down") then
        -- print("down")
        cameraY = math.floor(cameraY - cameraSpeed * dt)
        -- we use math.floor because otherwise text ui elements will be blurry
        self:draw()
    end
end

return map