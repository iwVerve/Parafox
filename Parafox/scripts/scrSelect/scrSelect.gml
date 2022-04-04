function selectResolveKeyboard(x1, y1, x2, y2)
{
	var xSel = getCoord(mouse_x, x1, x2, editing.width);
	var ySel = getCoord(mouse_y, y1, y2, editing.height);
	
	var xMove = (keyboard_check_pressed(ord("D")) + keyboard_check_pressed(vk_right) - keyboard_check_pressed(ord("A")) - keyboard_check_pressed(vk_left));
	var yMove = (keyboard_check_pressed(ord("W")) + keyboard_check_pressed(vk_up) - keyboard_check_pressed(ord("S")) - keyboard_check_pressed(vk_down));
	
	if (!keyboard_check(vk_control) && (xMove != 0 || yMove != 0))
	{
		if (selected != noone && selected.object_index != objLevel)
		{
			for(var i = 0; i < editing.width; i++)
			{
				for(var j = 0; j < editing.width; j++)
				{
					if (editing.children[# i, j] == selected)
					{
						var xx = i;
						var yy = j;
					}
				}	
			}
			if (xMove != 0 && inRange(xx + xMove, 0, editing.width - 1) && editing.children[# xx + xMove, yy] == noone)
			{
				editing.children[# xx, yy] = noone;
				editing.children[# xx + xMove, yy] = selected;
				xx += xMove;
			}
			if (yMove != 0 && inRange(yy + yMove, 0, editing.height - 1) && editing.children[# xx, yy + yMove] == noone)
			{
				editing.children[# xx, yy] = noone;
				editing.children[# xx, yy + yMove] = selected;
			}
		}
	}
	
	if (keyboard_check_pressed(vk_enter))
	{
		if (instance_exists(selected) && selected.object_index == objBlock)
		{
			editBlock(selected);
		}
	}
	
	if (keyboard_check_pressed(vk_delete))
	{
		if (instance_exists(selected) && selected.object_index != objLevel)
		{
			removeInstance(selected, true);
			selectInstance(noone);
		}
	}
	
	if (keyboard_check_pressed(vk_escape))
	{
		selectInstance(noone);
	}
	
	if (keyboard_check_pressed(vk_add) || keyboard_check_pressed(187))
	{
		var target = editing;
		if (selected != noone && selected.object_index == objBlock)
		{
			target = selected;
		}
		incrementBlockWidth(target);
		incrementBlockHeight(target);
	}
	
	if (keyboard_check_pressed(vk_subtract) || keyboard_check_pressed(189))
	{
		var target = editing;
		if (selected != noone && selected.object_index == objBlock)
		{
			target = selected;
		}
		decrementBlockWidth(target);
		decrementBlockHeight(target);
	}
}

function selectResolveMouse(x1, y1, x2, y2)
{
	if (!keyboard_check(vk_shift))
	{
		selectMouseSelect(x1, y1, x2, y2);
	}
	else
	{
		selectMouseDraw(x1, y1, x2, y2);
	}
}

function selectMouseSelect(x1, y1, x2, y2)
{
	if (!frameDelay && mouse_check_button_pressed(mb_left))
	{
		if (inRange(mouse_x, x1, x2) && inRange(mouse_y, y1, y2))
		{
			var xSel = getCoord(mouse_x, x1, x2, editing.width);
			var ySel = getCoord(mouse_y, y1, y2, editing.height);
			var inst = editing.children[# xSel, ySel];
			if (!is_undefined(inst) && instance_exists(inst))
			{
				if (selected == inst && doubleclickTimer > 0)
				{
					if (inst.object_index == objBlock)
					{
						editBlock(inst);
					}
					else if (inst.object_index == objRef)
					{
						var block = findIndex(inst.index);
						if (block != noone)
						{
							editBlock(block);
						}
						else
						{
							dragging = true;
							dragX = xSel;
							dragY = ySel;	
						}
					}
					else
					{
						dragging = true;
						dragX = xSel;
						dragY = ySel;	
					}
				}
				else
				{
					selectInstance(inst, xSel, ySel);
					doubleclickTimer = 25;
				}
			}
			else
			{
				selectInstance(noone);
			}
		}
		else
		{
			var deselect = true;
			with(objProperty)
			{
				if (hover)
				{
					deselect = false;
				}
			}
			if (deselect)
			{
				selectInstance(noone);
			}
		}
	}
	
	if (mouse_check_button_pressed(mb_right))
	{
		var deselect = true;
		with(objProperty)
		{
			if (hover)
			{
				deselect = false;
			}
		}
		if (deselect)
		{
			if (instance_exists(editing.owner) && editing.owner.object_index != objLevel)
			{
				editing = editing.owner;
			}
			selectInstance(noone);
		}
	}
	
	if (mouse_check_button(mb_left))
	{
		if (dragging)
		{
			dragInstance(x1, y1, x2, y2);
		}
	}
	else
	{
		dragging = false;
	}
}

function selectMouseDraw(x1, y1, x2, y2)
{
	var xSel = getCoord(mouse_x, x1, x2, editing.width);
	var ySel = getCoord(mouse_y, y1, y2, editing.height);
	
	if (mouse_check_button(mb_left))
	{
		if (editing.children[# xSel, ySel] == noone)
		{
			var wall = instance_create_layer(0, 0, "Level", objWall);
			wall.owner = editing;
			editing.children[# xSel, ySel] = wall;
			unsavedChanges = true;
		}
	}
	else if (mouse_check_button(mb_right))
	{
		var inst = editing.children[# xSel, ySel];
		if (inst != noone)
		{
			removeInstance(inst, true);
			selectInstance(noone);
			unsavedChanges = true;
		}
	}
}
