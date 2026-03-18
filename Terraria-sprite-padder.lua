--if you have data outside the bounds of the sprite, the script will not work
--this script will ask if you want your sprite scaled up by 2, to match terraria's pixel art style
--this script splits your pixel art into 16x16 tiles with 2 pixels of padding between them and on the bottom and rightmost edges of the canvas
--this script currently does not work on spritesheets, only single sprites, and assumes your art goes to the canvas edge
--this script will flatten your sprite into one layer

-- !!! make a SAVE of your sprite before running this script, in case it crashes for some reason

app.transaction(function()

    if app.sprite == nil then
        return
    end

    local flat1 = "Flatten All Layers"; local flat2 = "Flatten Visible Layers"
    local double1 = "Double Sprite Size, Then Pad"; local double2 = "Don't Double - Just Pad"
    local extra1 = "Split and Pad All Extra Pixels"; local extra2 = "Append All Extra Pixels on Bottom and Right Tiles"
    local extra3 = "Split and Pad Bottom; Append Right"; local extra4 = "Split and Pad Right; Append Bottom (best for sprites to extend into the ground)"
    
    local comboDialog = Dialog("Script Configuration")
    comboDialog:newrow {always = true }
    comboDialog:combobox {id = "flat", option = flat1, options = { flat1, flat2} }
    comboDialog:combobox {id = "double", option = double1, options = { double1, double2} }
    comboDialog:combobox {id = "extra", option = extra1, options = { extra1, extra2, extra3, extra4} }
    comboDialog:button {id = "go", text = "OK"}
    comboDialog:button {id = "cancel", text = "Go Back"}
    comboDialog:show()

    if comboDialog.data.cancel then return end

    local flatAllLayers = false; local doubleSpriteSize = false; local splitAndPadExtraOption = 1

    if comboDialog.data.flat == flat1 then flatAllLayers = true end
    if comboDialog.data.double == double1 then doubleSpriteSize = true end

    if comboDialog.data.extra == extra1 then splitAndPadExtraOption = 1
    else if comboDialog.data.extra == extra2 then splitAndPadExtraOption = 2
    else if comboDialog.data.extra == extra3 then splitAndPadExtraOption = 3
    else if comboDialog.data.extra == extra4 then splitAndPadExtraOption = 4
    end end end end

    local fileName = app.sprite.filename --get rid of ugly file extension in the middle of the new file name
    local lastDot = -1
    local newFileName
    for i = string.len(fileName), 1, -1 do --loop through filename backwards
        if string.byte(fileName, i) == 46 then --ascii 46 is period
            lastDot = i
            break
        end
    end

    if fileName == nil or lastDot == -1 then
        newFileName = "My-Padded-Sprite"
    else
        newFileName = fileName:sub(1, lastDot - 1) .. "-Copy"
    end    

    app.command.DuplicateSprite {filename = newFileName, ui=false} --duplicate the sprite to preserve the original

    -- double sprite size if requested
    if doubleSpriteSize or app.isUIAvailable == false then
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

    --splitting/appending logic
    local splitWidth = false
    local splitHeight = false

    if splitAndPadExtraOption == 1 then
        splitWidth = true
        splitHeight = true
    elseif splitAndPadExtraOption == 2 then
        splitWidth = false
        splitHeight = false
    elseif splitAndPadExtraOption == 3 then
        splitWidth = false
        splitHeight = true
    elseif splitAndPadExtraOption == 4 then
        splitWidth = true
        splitHeight = false
    end

    if widthExtra == 0 then --nothing to split
        splitWidth = false
    end
    if heightExtra == 0 then
        splitHeight = false
    end

    if splitWidth then
        widthSteps = widthSteps + 1
    end
    if splitHeight then
        heightSteps = heightSteps + 1
    end

    -- new bounds for the canvas with room for the padding
    local newBounds = Rectangle(0, 0, width + (2 * widthSteps), height + (2 * heightSteps))

    app.command.CanvasSize { ui=false, bounds=newBounds}

    if flatAllLayers then
        app.command.FlattenLayers {visibleOnly = false}
    else if not flatAllLayers then
        app.command.FlattenLayers {visibleOnly = true}
    end end

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
        app.command.MoveMask {target="content", wrap=false, direction="right", units="pixel", quantity= i*2}
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