function pasteResolveMouse(x1, y1, x2, y2)
{
	if (!frameDelay && mouse_check_button_pressed(mb_left))
	{
		var xSel = getCoord(mouse_x, x1, x2, editing.width);
		var ySel = getCoord(mouse_y, y1, y2, editing.height);
		
		var inst = editing.children[# xSel, ySel];
		if ((inRange(mouse_x, x1, x2)) && (inRange(mouse_y, y1, y2)))
		{	
			if (inst == noone)
			{
				var inst = pasteInstance(xSel, ySel);
				selectInstance(inst);
				
				unsavedChanges = true;
				tool = TOOL.SELECT;
			}
		}
		else
		{
			tool = TOOL.SELECT;
		}
	}
	
	if (mouse_check_button_pressed(mb_right))
	{
		tool = TOOL.SELECT;
	}
}
