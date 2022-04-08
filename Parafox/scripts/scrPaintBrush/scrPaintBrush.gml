function paintBrushResolveMouse(rect)
{
	if (!frameDelay && mouse_check_button(mb_left))
	{
		var xSel = getCoord(mouse_x, rect.x1, rect.x2, editing.width);
		var ySel = getCoord(mouse_y, rect.y1, rect.y2, editing.height);
		
		var inst = editing.children[# xSel, ySel];
		if (pointInRect(mouse_x, mouse_y, rect))
		{	
			if (instIsObject(inst, objBlock))
			{
				paintBlock(inst, paintBrushColor);
				unsavedChanges = true;
			}
			else if (instIsObject(inst, objRef))
			{
				paintBlock(findBlockByIndex(inst.index), paintBrushColor);
				unsavedChanges = true;
			}
			else
			{
				paintBlock(editing, paintBrushColor);
				unsavedChanges = true;
			}
		}
		else if (mouse_check_button_pressed(mb_left))
		{
			tool = TOOL.SELECT;	
		}
	}
	
	if (mouse_check_button_pressed(mb_right))
	{
		tool = TOOL.SELECT;
	}
}
