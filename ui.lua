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
    ui.lines[5] = {options = {}, }--y = ui.line_height * 5}
    do
        -- note: active option should get a color key
        ui.lines[5].options[1] = {substring = "3x3", color = {0.6,0.7,0.1}}
        ui.lines[5].options[2] = {substring = "5x5"}
        ui.lines[5].options[3] = {substring = "7x7"}
        ui.lines[5].options[4] = {substring = "none"}
    end

    ui.lines[6] = {substring = "", color = {1,1,1}, }--y = ui.line_height * 6}
    ui.lines[7] = {substring = "", color = {1,1,1}, }--y = ui.line_height * 6}
    ui.lines[8] = {substring = "brush terrain", color = {0.7, 0.7, 0.5}, }--y = ui.line_height * 7}
    ui.lines[9] = {options = {}, }--y = ui.line_height * 9}
    do
        ui.lines[9].options[1] = {substring = "GRASS", color = {0.6,0.7,0.1}}
        ui.lines[9].options[2] = {substring = "GRASS2"}
        ui.lines[9].options[3] = {substring = "GRASS3"}
        ui.lines[9].options[4] = {substring = "DIRT"}
        ui.lines[9].options[5] = {substring = "DIRT2"}
        ui.lines[9].options[6] = {substring = "DIRT3"}
        ui.lines[9].options[7] = {substring = "WATER"}
        ui.lines[9].options[8] = {substring = "MED_WATER"}
        ui.lines[9].options[9] = {substring = "DEEP_WATER"}
        ui.lines[9].options[10] = {substring = "SHALLOW"}
        ui.lines[9].options[11] = {substring = "FOREST"}
        ui.lines[9].options[12] = {substring = "JUNGLE"}
        ui.lines[9].options[13] = {substring = "ICE"}
        ui.lines[9].options[14] = {substring = "SNOW"}
        ui.lines[9].options[15] = {substring = "BEACH"}
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
        if v.options then
            local x = 20
            for j, option in ipairs(v.options) do
                -- note: the active brush option should get a special color
                love.graphics.setColor(option.color or {0.7, 0.7, 0.5})
                love.graphics.print(option.substring, x, y)
                y = y + ui.line_height
            end
        else
            love.graphics.setColor(v.color)
            love.graphics.print(v.substring, 10, y)
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