function selectResolveKeyboard(rect)
{
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
		updateWallIndexes(editing);
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
		updateWallIndexes(editing);
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
		updateWallIndexes(editing);
	}
}

function selectResolveMouse(rect)
{
	if (!keyboard_check(vk_shift))
	{
		selectMouseSelect(rect);
	}
	else
	{
		selectMouseDraw(rect);
	}
}

function selectMouseSelect(rect)
{
	if (!frameDelay && mouse_check_button_pressed(mb_left))
	{
		if (pointInRect(mouse_x, mouse_y, rect))
		{
			var xSel = getCoord(mouse_x, rect.x1, rect.x2, editing.width);
			var ySel = getCoord(mouse_y, rect.y1, rect.y2, editing.height);
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
						var block = findBlockByIndex(inst.index);
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
			dragInstance(rect);
		}
	}
	else
	{
		dragging = false;
	}
}

function selectMouseDraw(rect)
{
	var xSel = getCoord(mouse_x, rect.x1, rect.x2, editing.width);
	var ySel = getCoord(mouse_y, rect.y1, rect.y2, editing.height);
	
	if (mouse_check_button(mb_left))
	{
		if (editing.children[# xSel, ySel] == noone)
		{
			var wall = instance_create_layer(0, 0, "Level", objWall);
			wall.owner = editing;
			editing.children[# xSel, ySel] = wall;
			unsavedChanges = true;
			updateWallIndexes(editing);
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
			updateWallIndexes(editing);
		}
	}
}
