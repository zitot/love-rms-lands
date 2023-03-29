require "map"

local MAPSIZE = 10 -- size of the map
local tiles = {} -- table to store the tiles
local tileSize = 32 -- size of each tile in pixels
local angle = math.rad(-45) -- angle to rotate the map


local brush_terrain_type = "GRASS"
local brush_base_size = 1

terrain_type_list = {
    "GRASS", "GRASS2", "GRASS3", "DIRT", "DIRT2", "DIRT3", "WATER", "MED_WATER", "DEEP_WATER", "SHALLOW",
    "FOREST", "JUNGLE", "BEACH", "DESERT", "ROAD", "ICE", "SNOW"
}

local MINIMAP_TERRAIN_COLORS = {
    GRASS = {0.1, 0.79, 0.25},
    GRASS2 = {0.1, 0.79, 0.25},
    GRASS3 = {0.1, 0.79, 0.25},
    DIRT = {0.54, 0.27, 0.07},
    DIRT2 = {0.63, 0.32, 0.18},
    DIRT3 = {0.79, 0.65, 0.36},
    WATER = {0.0, 0.53, 0.74},
    MED_WATER = {0.12, 0.56, 1.0},
    DEEP_WATER = {0.0, 0.2, 0.4},
    SHALLOW = {0.4, 1.0, 1.0},
    FOREST = {0.13, 0.55, 0.13},
    JUNGLE = {0.18, 0.73, 0.47},
    ICE = {0.6, 1.0, 1.0},
    SNOW = {1.0, 1.0, 1.0},
    BEACH = {1.0, 1.0, 0}
}

-- NOTE: Should I draw all these to a spritesheet? undecided
-- NOTE: loading images could slow down startup significantly. Should I wait until after the editor loads to start loading sprites in?
local TERRAIN_SPRITES = {
    GRASS = love.graphics.newImage("textures/grass_tile.jpg"),
    GRASS2 = love.graphics.newImage("textures/grass2_tile.jpg"),
    GRASS3 = love.graphics.newImage("textures/grass3_tile.jpg"),
    DIRT = love.graphics.newImage("textures/dirt_tile.png"),
    DIRT2 = love.graphics.newImage("textures/dirt2_tile.png"),
    DIRT3 = love.graphics.newImage("textures/dirt3_tile.png"),
    WATER = love.graphics.newImage("textures/water_tile.png"),
    MED_WATER = love.graphics.newImage("textures/med_water_tile.png"),
    DEEP_WATER = love.graphics.newImage("textures/deep_water_tile.png"),
    SHALLOW = love.graphics.newImage("textures/shallow_tile.png"),
    FOREST = love.graphics.newImage("textures/forest_tile.png"),
    JUNGLE = love.graphics.newImage("textures/jungle_tile.png"),
    ICE = love.graphics.newImage("textures/ice_tile.png"),
    SNOW = love.graphics.newImage("textures/snow_tile.png"),
    BEACH = love.graphics.newImage("textures/beach_tile.png"),
}

-- if a nonexistent terrain is accessed, use black
setmetatable(MINIMAP_TERRAIN_COLORS, {__index = function(t) return {1,0,0} end})

-- initialize the tiles
for i = 1, MAPSIZE do
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

function love.conf(t)
    t.console = true
    t.window.width = 2048
    t.window.height = 768
    t.modules.joystick = false
    t.modules.physics = false

end

local grid_state = "dashed" -- off, dashed, dotted, solid
local cameraX = 0
local cameraY = 0
local cameraSpeed = 1000 -- pixels per second

local canvas = love.graphics.newCanvas()

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

-- function to draw the map
local function drawMap()
    -- local textElements = {}

    love.graphics.setCanvas(canvas) -- set canvas as active drawing target
    love.graphics.clear() -- clear the canvas

    -- perform drawing operations here
    love.graphics.push()
    -- NOTE: why am I translating to the camera now?? Doesn't this belong in love.draw()??
    love.graphics.translate(cameraX, cameraY)
    love.graphics.rotate(angle)

    -- love.graphics.setLineWidth(2) -- set line width to 5 pixels
    for i = 1, MAPSIZE do
        for j = 1, MAPSIZE do
            -- NOTE: why am i subtracting MAPSIZE / 2 from i? I don't recall, not at all
            local x = (i - MAPSIZE / 2) * tileSize
            local y = (j - MAPSIZE / 2) * tileSize

            -- FIXME: Cannot use x = i*tileSize without screwing up touch coordinates
            -- local x = i * tileSize
            -- local y = j * tileSize
            local terrain_type =  tiles[i][j].terrain_type
            -- draw minimap
            -- love.graphics.setColor(MINIMAP_TERRAIN_COLORS[terrain_type])
            -- love.graphics.rectangle("fill", x, y, tileSize, tileSize) 

            -- draw main view of map (with sprites and stuff)
            -- NOTE: Is it more efficient to draw all our sprites to a REALLY big canvas and translate around that image 
            -- or should I just draw those tiles that fit into the current window?
            -- (I assume love2d doesn't waste computational power trying to render things out of window bounds)
            -- let's be naive and draw the whole map it's not like my cpu/gpu cares

            -- The origin is by default located at the top left corner of Image and Canvas objects
            love.graphics.setColor(1,1,1)
            local sprite = TERRAIN_SPRITES[terrain_type]
            love.graphics.draw(sprite, x, y)

            -- love.graphics.push()
            -- love.graphics.translate(x + tileSize / 2, y + tileSize / 2)
            -- love.graphics.rotate(-angle)
            -- love.graphics.setColor(1, 1, 1)
            -- local textX = cameraX
            -- local textY = cameraY
            -- textX = x + (tileSize / 2) - 3
            -- textY = y + (tileSize / 2) - 6
            -- love.graphics.print(tiles[i][j].substring, -3, -6)
            -- table.insert(textElements, {x = textX, y = textY, substring = tiles[i][j].substring})
            -- love.graphics.pop()

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

    -- for i = 1, #textElements do
        -- love.graphics.print(textElements[i].substring, textElements[i].x, textElements[i].y)
    -- end
    love.graphics.setCanvas() -- reset active drawing target to screen

end

local function paintTile(row,col)
    -- paint the tile at row,col
    -- will overwrite neighboring tiles
    neighbors = MAPSIZE
end

-- function to handle touches and clicks
local function handleTouch(x, y)
    -- x = x - love.graphics.getWidth() / 2
    -- y = y - love.graphics.getHeight() / 2

    x = x - cameraX
    y = y - cameraY



    local c = math.cos(-angle)
    local s = math.sin(-angle)

    x, y = c * x - s * y, s * x + c * y

    local i = math.floor(x / tileSize + MAPSIZE / 2) 
    local j = math.floor(y / tileSize + MAPSIZE / 2) 

    if i >= 1 and i <= MAPSIZE and j >= 1 and j <= MAPSIZE then
        special_text_to_draw_in_top_right_corner = tiles[i][j].terrain_type ..
         "\nx:" .. i .. "\ny:" .. j 
        -- tiles[i][j].substring = string.char(math.random(65, 90))
    end
end

special_text_to_draw_in_top_right_corner = ""
-- Love2D callbacks
function love.draw()
    love.graphics.setColor(0, 1, 0)
    love.graphics.print(special_text_to_draw_in_top_right_corner, 10, 10)
    local major, minor, revision, codename = love.getVersion()
    local str = string.format("Version %d.%d.%d - %s", major, minor, revision, codename)
    love.graphics.print(str, 500, 20)
    love.graphics.setColor(1,1,1)
    love.graphics.draw(canvas) -- draw canvas onto screen
end

function love.mousepressed(x, y)
    handleTouch(x, y)
end

function love.touchpressed(id, x, y)
    handleTouch(x, y)
end

function love.update(dt)
    if love.keyboard.isDown("left") then
        cameraX = math.floor(cameraX + cameraSpeed * dt)
        -- we use math.floor because otherwise text ui elements will be blurry
        drawMap() --FIXME: I should not be redrawing the map each frame
                    -- TODO: decouple the translation of the camera from the drawing of the map
    elseif love.keyboard.isDown("right") then
        cameraX = math.floor(cameraX - cameraSpeed * dt)
        -- we use math.floor because otherwise text ui elements will be blurry
        drawMap()
    end

    if love.keyboard.isDown("up") then
        print("up")
        cameraY = math.floor(cameraY + cameraSpeed * dt)
        -- we use math.floor because otherwise text ui elements will be blurry
        drawMap()
    elseif love.keyboard.isDown("down") then
        print("down")
        cameraY = math.floor(cameraY - cameraSpeed * dt)
        -- we use math.floor because otherwise text ui elements will be blurry
        drawMap()
    end
end



function love.load()
    
    drawMap() -- draw map onto screen
end
