--if you have data outside the bounds of the sprite, the script will not work
--this script will ask if you want your sprite scaled up by 2, to match terraria's pixel art style
--this script splits your pixel art into 16x16 tiles with 2 pixels of padding between them and on the bottom and rightmost edges of the canvas
--this script currently does not work on spritesheets, only single sprites, and assumes your art goes to the canvas edge
--this script will flatten your sprite into one layer

-- !!! make a SAVE of your sprite before running this script, in case it crashes for some reason

app.transaction(function()    

    local dlg = Dialog("Double Sprite Size?")    
    dlg:button {id = "dbl", text = "Double Size, Then Pad", focus = true}
    dlg:button {id = "nodbl", text = "No, Only Pad"}
    dlg:show()

    app.command.DuplicateSprite {filename = app.sprite.filename .. "-Copy",ui=false} --duplicate the sprite to preserve the original

    -- double sprite size if requested
    if dlg.data.dbl then
        app.command.SpriteSize {ui = false, scale=2} 
    end

    local width = app.sprite.width
    local height = app.sprite.height

    -- if the size of the sprite is not a multiple of 16, the extra pixels will be on the bottom and rightmost tiles
    --read more about how terraria's tiles work here: https://github.com/tModLoader/tModLoader/wiki/Basic-Tile
    local widthExtra = width % 16
    local heightExtra = height % 16
    local widthSteps = (width - widthExtra) / 16 --find how many steps of 16 pixels to take for the width and height
    local heightSteps = (height - heightExtra) / 16

    -- new bounds for the canvas with room for the padding
    local newBounds = Rectangle(0, 0, width + (2 * widthSteps), height + (2 * heightSteps))

    app.command.CanvasSize { ui=false, bounds=newBounds}

    app.command.FlattenLayers {}

    local newWidth = app.sprite.width
    local newHeight = app.sprite.height

    local rect = Rectangle(0, 0, newWidth, newHeight) --empty rectangle

    --width
    for i = widthSteps - 1, 1, -1 do
        --if there are extra pixels, the first condition ensures they are moved with the rightmost tiles
        if i == widthSteps - 1 then     
            rect = Rectangle(i * 16, 0, 16, newHeight + widthExtra)
        else
            rect = Rectangle(i * 16, 0, 16, newHeight)
        end

        local selection = Selection(rect)
        
        --select, move, clear selection
        app.sprite.selection = selection
        app.command.MoveMask {target='content', wrap=false, direction="right", units="pixel", quantity= i*2}
        app.command.DeselectMask {}
    end

    --height
    for i = heightSteps - 1, 1, -1 do 
        --if there are extra pixels, the first condition ensures they are moved with the bottom tiles
        if i == heightSteps - 1 then
            rect = Rectangle(0, i * 16, newWidth, 16 + heightExtra)
        else
            rect = Rectangle(0, i * 16, newWidth, 16)
        end
        
        local selection = Selection(rect)
        
        --select, move, clear selection
        app.sprite.selection = selection
        app.command.MoveMask {target='content', wrap=false, direction="down", units="pixel", quantity= i*2}
        app.command.DeselectMask {}
    end
end)