## Download
[Download v1.0](https://github.com/josh20504/Terraria-Sprite-Padder-for-Aseprite/raw/v1.0/Terraria-sprite-padder.lua)
# Terraria Sprite Padder for Aseprite
A .lua script for use with Aseprite to help you pad your sprites for use as multi-tiles in a Terraria mod or Texture pack  
Drag and drop this file into your Aseprite scripts folder, which can be easily accessed here:  
![directions](/directions.png)  
To execute, click on the name of the script that should appear in the same scripts menu (you may need to rescan scripts folder)
## What it does
This script will pad your sprite to work with Terrarias conventions for multi-tile sprites, you can read more about this [here](https://github.com/tModLoader/tModLoader/wiki/Basic-Tile).  
A visual example \(green arrow not included):  
![example](/example.png)  
* You can choose whether or not the script will scale up the sprite before applying its other transforms
* If the size of the scaled up sprite is not a multiple of 16, the extra pixels will be on the bottom and rightmost tiles. This is useful on the bottom tiles if you want your sprite to extend into the ground
* This script assumes default conditions i.e. 16 x 16 tiles with 2 pixels of padding. There are currently no parameters to change this
* This script currently only works on singular sprites, not spritesheets or animations
* The sprite is duplicated before any changes are made, and all following transformations are performed on the duplicate, but still save your work before running this script
* The script will flatten the sprites layers, including hidden ones
* It's a bit scuffed, but you can step back through all the transformations by using undo on the final product
* ## Feedback
* For feedback and/or bug reports, or even if you just wanna chat, create an [issue](https://github.com/josh20504/Terraria-Sprite-Padder-for-Aseprite/issues)
