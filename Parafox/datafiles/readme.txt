--Parafox-- (1.1.1.1)
A level editor for Patrick's Parabox
  (https://store.steampowered.com/app/1260520/Patricks_Parabox/)
Made by Verve
  (https://twitter.com/IwVerve)


--Playing levels--
See https://www.patricksparabox.com/custom-levels/ to find your custom levels folder.
On Windows, you might be able to use the path
%appdata%\..\LocalLow\Patrick Traynor\Patrick's Parabox\custom_levels\
and the editor should open that folder by default.
Once you save your level there and open it in-game, you can press F5 at any time to reload the
level file. This allows quick testing of changes without having to navigate the game menu.


--Level structure--
This section explains what each of the basic building blocks does. If you're looking to make a
specific game object, the next section might be more directly helpful.
Levels consists of 4 different types of objects.

-Blocks include everything from simple plain boxes to entire rooms. The player is also a Block.
-Each Block has an index, to be used by References. Each Block should have its own index, and the
editor will assign the lowest unused value everytime you make a Block.
-The "Fill with walls" property turns a block into a solid filled square.
-The "Float in space" property places the block outside of the main Block, making it inaccesible
without References.

-References are copies of specific Blocks. Blocks and References are connected by their index value.
-The "Exit Block" property allows the player to leave the referenced Block, and exit wherever the
Reference is. This is needed to allow exiting a Block placed in itself, instead of only entering.
-Infinite exit and enter, and their corresponding properties are used to make infinity and epsilon
levels, and are further explained below.

-Walls are not very interesting. To allow quick placement, instead of being placed like the other
objects, use Shift + Left mouse to place them.

-Floors are two types of buttons - regular and player buttons.
-Since the editor doesn't allow stacking objects, if you ever need an object to start over a button,
you should use the "Placed on" property of that object instead of placing a button.


--How to make specific game objects--
-Wall - Shift + Left click
-Player - The player is a Block with "Fill with walls", "Player", and "Possessable" checked.
-Push box - A simple pushable box is a Block with "Fill with walls" checked. If you need to place
several, copying and pasting should save you time.
-Button - Buttons are Floors.
-Clone - A clone is a Reference without "Exit block" check.
-Level inside itself - A Reference with "Exit block" checked will allow you to exit the Block it
references and exit outside of the Reference.
-Infinity block - Simply check "Infinite exit", with "Infinite exit num" setting how many levels
of infinity. Requires a level to be inside itself, through the use of an Exit block Reference.


--Epsilon block--
Infinite enter blocks are both hard to understand and a hassle to make. For technical reasons, only
a Reference can be an epsilon block, even when it being a regular Block would make sense. To work
around this, place the actual block anywhere in the level, check "Float in space", and make a
Reference to it with "Exit Block" checked.
Each epsilon block can only be entered from one block - its Infinite enter index. The Infinite
Enter Number sets the amount of layers (amount of epsilons), 0 being 1 epsilon.


--Palettes--
If the level palette is not set to -1, the game will apply a palette based on specific color values:
0 saturation - color A, usually gray, for root blocks
0.6 hue - color B, usually blue, for blocks
0.4 hue - color C, usually green, for blocks
0.1 hue - color D, usually orange, for solid blocks
0.9 hue - color E, usually pink, for player
0.55 hue - color F, usually teal, for levels that need an additional block color


--Shortcomings--
The editor currently has no undo and group select feature. Maybe one day...


--Controls, shortcuts--
Double click a Block or Reference to start editing it
Right click to move one layer up, or to cancel current action
Shift + Left click to draw walls
Shift + Right click to delete

Ctrl+S - Save
` - Edit level properties
1 - Place Block
2 - Place Reference
3 - Place Floor
Tab - Grid View
Delete - Delete selected object
Ctrl+C - Copy
Ctrl+X - Cut
Ctrl+V - Paste
+ - Increase width and height of selected object by 1
- - Decrease width and height of selected object by 1

When editing a Reference, you can right click the index property. Then, clicking on a Block will
assign that Block's index to the Reference.