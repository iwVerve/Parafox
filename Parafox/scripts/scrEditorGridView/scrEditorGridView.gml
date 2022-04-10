function gridViewStep()
{
	if (keyboard_check_pressed(vk_tab))
	{
		view = EDITORVIEW.EDIT;
		selectInstance(noone);
	}
	
	var blockArray = getGridViewBlockArray();
	var squareSize = 0.9 * min(room_width, room_height);
	var divisions = ceil(sqrt(array_length(blockArray)));
	
	var xCenter = room_width/2;
	var yCenter = room_height/2;
	var gridRect = new Rect(xCenter - squareSize/2, yCenter - squareSize/2, xCenter + squareSize/2, yCenter + squareSize/2);
	
	for(var i = 0; i < divisions; i++)
	{
		for(var j = 0; j < divisions; j++)
		{
			var index = divisions * i + j;
			var arrayIndex = array_length(blockArray) - index - 1;
			if (index < array_length(blockArray))
			{
				var block = blockArray[arrayIndex];
				var blockRect = new Rect(
					lerp(gridRect.x1, gridRect.x2, j/divisions),
					lerp(gridRect.y1, gridRect.y2, i/divisions),
					lerp(gridRect.x1, gridRect.x2, (j+1)/divisions),
					lerp(gridRect.y1, gridRect.y2, (i+1)/divisions)
				);
				blockRect.scale(0.8);
				
				if (!frameDelay && mouse_check_button_pressed(mb_left) && pointInRect(mouse_x, mouse_y, blockRect))
				{
					gridViewResolveMouse(block, blockArray, arrayIndex);
				}
			}
		}
	}
}

function gridViewDraw()
{
	var blockArray = getGridViewBlockArray();
	var squareSize = 0.9 * min(room_width, room_height);
	var divisions = ceil(sqrt(array_length(blockArray)));
	
	var xCenter = room_width/2;
	var yCenter = room_height/2;
	var gridRect = new Rect(xCenter - squareSize/2, yCenter - squareSize/2, xCenter + squareSize/2, yCenter + squareSize/2);
	
	for(var i = 0; i < divisions; i++)
	{
		for(var j = 0; j < divisions; j++)
		{
			var index = divisions * i + j;
			var arrayIndex = array_length(blockArray) - index - 1;
			if (index < array_length(blockArray))
			{
				var block = blockArray[arrayIndex];
				var blockRect = new Rect(
					lerp(gridRect.x1, gridRect.x2, j/divisions),
					lerp(gridRect.y1, gridRect.y2, i/divisions),
					lerp(gridRect.x1, gridRect.x2, (j+1)/divisions),
					lerp(gridRect.y1, gridRect.y2, (i+1)/divisions)
				);
				blockRect.scale(0.8);
				with(block)
				{
					draw(blockRect, 0);
				}
				draw_set_halign(fa_left);
				draw_set_valign(fa_bottom);
				draw_set_color(c_white);
				var scale = clamp(squareSize/(300 * divisions), 0.2, 1);
				var offset = 2/divisions;
				draw_text_transformed(blockRect.x1 + offset, blockRect.y1 - offset, string(block.index) + ((instIsObject(block.owner, objLevel)) ? " (Root)" : ""), scale, scale, 0);
			}
		}
	}
}

function getGridViewBlockArray()
{
	var array = array_create(0);
	with(objBlock)
	{
		if (!fillWithWalls)
		{
			array_push(array, id);
		}
	}
	return array;
}

function gridViewResolveMouse(block, blockArray, index)
{
	switch(tool)
	{
		case TOOL.SELECT:
			editing = block;
			selectInstance(noone);
			view = EDITORVIEW.EDIT;
			break;
		case TOOL.GRIDDELETE:
			removeInstance(block, true);
			if (instIsObject(block.owner, objLevel))
			{
				ds_list_delete(level.rootBlocks, ds_list_find_index(level.rootBlocks, block));
			}
			blockArray = getGridViewBlockArray();
			if (!keyboard_check(vk_shift) && array_length(blockArray) > 1)
			{
				tool = TOOL.SELECT;
			}
			break;
	}
}
