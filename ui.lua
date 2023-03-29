-- left side user interface, contains labels for brushes and eventually button logic?
local ui = {}

ui.ishidden = false

do
    ui.line_height = 14
    ui.lines = {}
    ui.lines[1] = {substring = "TILE", color = {1,1,0},       }--y = ui.line_height * 1}
    ui.lines[2] = {substring = "x:     y:   ", color = {1,1,1},       }--y = ui.line_height * 2}
    ui.lines[3] = {substring = "", color = {1,1,1},                   }--y = ui.line_height * 3}
    ui.lines[4] = {substring = "brush size", color = {0.7, 0.7, 0.5}, }--y = ui.line_height * 4}
    ui.lines[5] = {select = {}, }--y = ui.line_height * 5}
    do
        -- note: active option should get a color key
        ui.lines[5].select[1] = {substring = "3x3", color = {0.6,0.7,0.1}}
        ui.lines[5].select[2] = {substring = "5x5"}
        ui.lines[5].select[3] = {substring = "7x7"}
        ui.lines[5].select[4] = {substring = "none"}
    end

    ui.lines[6] = {substring = "", color = {1,1,1}, }--y = ui.line_height * 6}
    ui.lines[7] = {substring = "", color = {1,1,1}, }--y = ui.line_height * 6}
    ui.lines[8] = {substring = "brush terrain", color = {0.7, 0.7, 0.5}, }--y = ui.line_height * 7}
    ui.lines[9] = {select = {}, }--y = ui.line_height * 9}
    do
        ui.lines[9].select[1] = {substring = "GRASS", color = {0.6,0.7,0.1}}
        ui.lines[9].select[2] = {substring = "GRASS2"}
        ui.lines[9].select[3] = {substring = "GRASS3"}
        ui.lines[9].select[4] = {substring = "DIRT"}
        ui.lines[9].select[5] = {substring = "DIRT2"}
        ui.lines[9].select[6] = {substring = "DIRT3"}
        ui.lines[9].select[7] = {substring = "WATER"}
        ui.lines[9].select[8] = {substring = "MED_WATER"}
        ui.lines[9].select[9] = {substring = "DEEP_WATER"}
        ui.lines[9].select[10] = {substring = "SHALLOW"}
        ui.lines[9].select[11] = {substring = "FOREST"}
        ui.lines[9].select[12] = {substring = "JUNGLE"}
        ui.lines[9].select[13] = {substring = "ICE"}
        ui.lines[9].select[14] = {substring = "SNOW"}
        ui.lines[9].select[15] = {substring = "BEACH"}
    end

    ui.lines[10] = {}
    ui.lines[11] = {}
    ui.lines[12] = {substring = "Options", color = {0.7, 0.7, 0.5}, }
    ui.lines[13] = {select = {multiple = true}}
    do
        ui.lines[13].select[1] = {substring = "[X] Lua" }
        ui.lines[13].select[2] = {substring = "[ ] Rms" }
    end
    ui.lines[14] = {}
    ui.lines[15] = {substring = "Save Now", color = {0.7, 0.7, 0.5}, }
    ui.lines[16] = {}
    ui.lines[17] = {}
    ui.lines[18] = {substring = "Map Size:", color = {0.7, 0.7, 0.5}, }
end

function ui.setMapSize(mapsize)
    if mapsize then
        ui.mapsize = mapsize
        ui.lines[18].substring = "Map Size  " .. mapsize
    end
end

function ui.draw()
    local HEIGHT = love.graphics.getHeight()

    -- fills left side with a brown rectangle. args: mode, x, y, w, h
    love.graphics.setColor(0.3, 0.2, 0.1)
    love.graphics.rectangle("fill", 0, 0, 144, HEIGHT)
    -- TODO: Add bezel to right edge. Maybe replace rectangle with a sprite?
    -- 

    local y = ui.line_height
    for i,v in ipairs(ui.lines) do
        if v.select then
            local x = 20
            for j, option in ipairs(v.select) do
                -- note: the active brush option should get a special color
                love.graphics.setColor(option.color or {0.7, 0.7, 0.5})
                love.graphics.print(option.substring, x, y)
                y = y + ui.line_height
            end
        else
            if v.color then
                love.graphics.setColor(v.color)
            end
            if v.substring then
                love.graphics.print(v.substring, 10, y)
            end
            y = y + ui.line_height
        end
    end


    -- add brush base size options
    love.graphics.setColor(0.7, 0.7, 0.5)
    -- note: base_size 1 = 3x3, 2 = 5x5, 3 = 7x7, ... I provide sizes up to 9x9


    -- add brush terrain type options

    -- add label

end








return ui