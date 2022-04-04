function placeRefResolveMouse(rect)
{
	if (!frameDelay && mouse_check_button_pressed(mb_left))
	{
		var xSel = getCoord(mouse_x, rect.x1, rect.x2, editing.width);
		var ySel = getCoord(mouse_y, rect.y1, rect.y2, editing.height);
		
		var inst = editing.children[# xSel, ySel];
		if ((inRange(mouse_x, rect.x1, rect.x2)) && (inRange(mouse_y, rect.y1, rect.y2)))
		{	
			if (inst == noone)
			{
				var ref = instance_create_layer(0, 0, "Level", objRef);
				ref.owner = editing;
				editing.children[# xSel, ySel] = ref
				selectInstance(ref);
				
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
