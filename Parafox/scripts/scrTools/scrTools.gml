function resolveTool(tool, x1, y1, x2, y2)
{
	resolveGlobal(x1, y1, x2, y2);
	switch(tool)
	{
		case TOOL.SELECT:
			selectResolveKeyboard(x1, y1, x2, y2);
			selectResolveMouse(x1, y1, x2, y2);
			break;
		case TOOL.PLACEBLOCK:
			placeBlockResolveMouse(x1, y1, x2, y2);
			break;
		case TOOL.PLACEREF:
			placeRefResolveMouse(x1, y1, x2, y2);
			break;
		case TOOL.PLACEFLOOR:
			placeFloorResolveMouse(x1, y1, x2, y2);
			break;
		case TOOL.LINKREF:
			linkRefResolveMouse(x1, y1, x2, y2);
			break;
		case TOOL.PASTE:
			pasteResolveMouse(x1, y1, x2, y2);
			break;
	}
}

function resolveGlobal(x1, y1, x2, y2)
{
	if (keyboard_check_pressed(192)) //Tilde
	{
		selectInstance(level);
	}
	
	if (keyboard_check_pressed(ord("1")))
	{
		tool = TOOL.PLACEBLOCK;
	}
	else if (keyboard_check_pressed(ord("2")))
	{
		tool = TOOL.PLACEREF;
	}
	else if (keyboard_check_pressed(ord("3")))
	{
		tool = TOOL.PLACEFLOOR;
	}
	
	if (keyboard_check(vk_control))
	{
		var xSel = getCoord(mouse_x, x1, x2, editing.width);
		var ySel = getCoord(mouse_y, y1, y2, editing.height);
		
		checkClipboardControls(xSel, ySel);
		
		if (keyboard_check_pressed(ord("S")))
		{
			saveMap(id, filePath);
		}
	}
}

function getToolText(tool)
{
	switch(tool)
	{
		case TOOL.SELECT:
			if (keyboard_check(vk_shift))
			{
				return "Draw walls/Delete";
			}
			return "Select/Deselect";
		case TOOL.PLACEBLOCK:
			return "Place new Block";
		case TOOL.PLACEREF:
			return "Place new Reference";
		case TOOL.PLACEFLOOR:
			return "Place new Floor";
		case TOOL.LINKREF:
			return "Link Reference to Block";
		case TOOL.PASTE:
			return "Paste object";
		default:
			return "";
	}
}
