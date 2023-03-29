-- map.lua

function love.conf(t)
	t.console = true
end

function love.draw()
    local major, minor, revision, codename = love.getVersion()
    local str = string.format("Version %d.%d.%d - %s", major, minor, revision, codename)
    love.graphics.print(str, 20, 20)
end

local map = {}

function createLand(terrainType)
	local land = [[
	create_land
	{
		hello world
	}]]
	terrainType = terrainType or "GRASS" 

end

print(createLand())










