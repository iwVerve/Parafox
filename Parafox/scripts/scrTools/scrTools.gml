function resolveTool(tool, rect)
{
	resolveGlobal(rect);
	switch(tool)
	{
		case TOOL.SELECT:
			selectResolveKeyboard(rect);
			selectResolveMouse(rect);
			break;
		case TOOL.PLACEBLOCK:
			placeBlockResolveMouse(rect);
			break;
		case TOOL.PLACEREF:
			placeRefResolveMouse(rect);
			break;
		case TOOL.PLACEFLOOR:
			placeFloorResolveMouse(rect);
			break;
		case TOOL.LINKREF:
			linkRefResolveMouse(rect);
			break;
		case TOOL.PASTE:
			pasteResolveMouse(rect);
			break;
		case TOOL.DRAWWALLS:
			drawWallsResolveMouse(rect);
			break;
		case TOOL.PAINTBRUSH:
			paintBrushResolveMouse(rect);
			break;
	}
}

function resolveGlobal(rect)
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
	
	if (keyboard_check_pressed(vk_tab))
	{
		deselectInstance();
		view = EDITORVIEW.GRID;
	}
	
	if (keyboard_check(vk_control))
	{
		var xSel = getCoord(mouse_x, rect.x1, rect.x2, editing.width);
		var ySel = getCoord(mouse_y, rect.y1, rect.y2, editing.height);
		
		checkClipboardControls(xSel, ySel);
		
		if (keyboard_check_pressed(ord("S")))
		{
			saveMap(id, filePath);
		}
		
		if (keyboard_check_pressed(ord("Z")))
		{
			undoAction(objEditor);
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
		case TOOL.DRAWWALLS:
			return "Draw walls/Cancel";
		case TOOL.PAINTBRUSH:
			return "Paint Blocks/Cancel";
		default:
			return "";
	}
}
