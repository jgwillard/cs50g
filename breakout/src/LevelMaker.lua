LevelMaker = Class{}

function LevelMaker.createMap(level)
    local bricks = {}
    local numRows = math.random(1, 5)
    local numCols = math.random(7, 13)

    for y = 1, numRows do
        for x = 1, numCols do
            b = Brick(
                -- x-coordinate
                (x - 1) -- decrement x by 1 bc tables are 1-indexed
                * 32 -- multiply by brick width
                + 8 -- 8 pixels of padding
                + (13 - numCols) * 16, -- left-sdie padding for <13 cols
                -- y-coordinate
                y * 16 -- vertical padding
            )

            table.insert(bricks, b)
        end
    end
    
    return bricks
end
