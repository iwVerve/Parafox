function linkRefResolveMouse(x1, y1, x2, y2)
{
	if (mouse_check_button_pressed(mb_left))
	{
		var xSel = getCoord(mouse_x, x1, x2, editing.width);
		var ySel = getCoord(mouse_y, y1, y2, editing.height);
		
		var inst = editing.children[# xSel, ySel];
		if (inst != noone)
		{
			if (inst.object_index == objBlock)
			{
				selected.index = inst.index;
			}
			else if (inst.object_index == objRef)
			{
				selected.index = inst.index;
			}
			else if (inRange(mouse_x, x1, x2) && inRange(mouse_y, y1, y2))
			{
				selected.index = editing.index;
			}
		}
		else
		{
			selected.index = editing.index;
		}
		unsavedChanges = true;
		tool = TOOL.SELECT;
	}
	
	if (!frameDelay && mouse_check_button_pressed(mb_right))
	{
		tool = TOOL.SELECT;
	}
}
