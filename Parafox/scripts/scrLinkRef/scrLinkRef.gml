function linkRefResolveMouse(rect)
{
	if (mouse_check_button_pressed(mb_left))
	{
		var xSel = getCoord(mouse_x, rect.x1, rect.x2, editing.width);
		var ySel = getCoord(mouse_y, rect.y1, rect.y2, editing.height);
		
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
			else if (inRange(mouse_x, rect.x1, rect.x2) && inRange(mouse_y, rect.y1, rect.y2))
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
