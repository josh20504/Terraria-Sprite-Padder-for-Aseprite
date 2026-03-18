## Download
[Download v1.0](https://github.com/josh20504/Terraria-Sprite-Padder-for-Aseprite/releases/download/v1.0/Terraria-sprite-padder.lua)  
If the download link does not work, save Terraria-sprite-padder.lua in the releases section
# Terraria Sprite Padder for Aseprite
A .lua script for use with Aseprite to help you pad your sprites for use as multi-tiles in a Terraria mod or Texture pack.  
Drag and drop this file into your Aseprite scripts folder, which can be easily accessed here:  
![directions](/directions.png)  
To execute, click on the name of the script that should appear in the same scripts menu (you may need to rescan scripts folder)
## What it does
This script will pad your sprite to work with Terrarias conventions for multi-tile sprites, you can read more about this [here](https://github.com/tModLoader/tModLoader/wiki/Basic-Tile).  
A visual example \(green arrow not included):  
![example](/example.png)  
* **The sprite is duplicated before any changes are made.** All following transformations are performed on the duplicate, but still save your work before running this script! (it really shouldn't crash, [but if it does](https://github.com/josh20504/Terraria-Sprite-Padder-for-Aseprite/issues))
* The script will flatten the sprites layers, you can choose to flatten all layers or only visible layers (note that any layers not flattened will be untouched by the transform)
* You can choose whether or not the script will scale up the sprite before applying its other transforms
* You can choose how the script behaves when the scaled-up version of your sprite has dimensions that are not divisible by 16 (what happens to the **overflow pixels** i.e. the result of your scaled-up sprites dimensions modulo 16):
  *   **Split and Pad All Extra Pixels:** both vertical and horizontal overflow pixels will be split into their own tiles on the bottom and right of the padded sprite.
  *   **Append All Extra Pixels on Bottom and Right Tiles:** both vertical and horizontal overflow pixels will be included as a part of the bottom and rightmost tiles on the padded sprite
  *   **Split and Pad Bottom; Append Right:** vertical overflow pixels will be split into new tiles, horizontal overflow pixels will be included in the rightmost tiles (not sure why you would pick this one)
  *   **Split and Pad Right, Append Bottom:** vertical overflow pixels will be included on the bottom tiles, horizontal overflow pixels will be split into new tiles
  *   If your Terraria sprite is going to sit on the ground, it is recommended to have the bottom tiles be 18 pixels high instead of 16 so it extends into the ground a bit. Any option that appends bottom will do this.
  *   If your Terraria sprite goes to all edges of the canvas, needs to be scaled up *and* the scaled up dimensions are divisible by 16, you can leave all settings on default
* This script targets default conditions i.e. 16 x 16 tiles with 2 pixels of padding. There are currently no parameters to change this
* This script currently only works on singular sprites, not spritesheets or animations
* It's a bit scuffed, but you can step back through all the transformations by using undo on the final product
* This script uses dialogs to determine its behaviour, full functionality cannot be used from the command line interface 
* ## Feedback
* For feedback and/or bug reports, or even if you just wanna chat, create an [issue](https://github.com/josh20504/Terraria-Sprite-Padder-for-Aseprite/issues)
