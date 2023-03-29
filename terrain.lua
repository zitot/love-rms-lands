local terrain = {}

local terrain_type_list = {
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

-- if a nonexistent terrain is accessed, use red
setmetatable(MINIMAP_TERRAIN_COLORS, {__index = function(t) return {0.5,0,0} end})

-- NOTE: Should I draw all these to a spritesheet? undecided
-- NOTE: loading images could slow down startup significantly. Should I wait until after the editor loads to start loading sprites in?
terrain.sprites = {
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


return terrain