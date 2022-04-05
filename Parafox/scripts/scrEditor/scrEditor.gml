function removeInstance(inst, destroy)
{
	if (inst.object_index == objBlock)
	{
		for(var i = 0; i < inst.width; i++)
		{
			for(var j = 0; j < inst.height; j++)
			{
				var childInst = inst.children[# i, j];
				if (childInst != noone)
				{
					removeInstance(childInst, true);
				}
			}
		}
	}
	var instOwner = inst.owner;
	for(var i = 0; i < instOwner.width; i++)
	{
		for(var j = 0; j < instOwner.height; j++)
		{
			if (instOwner.children[# i, j] == inst)
			{
				instOwner.children[# i, j] = noone;
				if (destroy)
				{
					instance_destroy(inst);
				}
				else
				{
					inst.owner = noone;
				}
				unsavedChanges = true;
				exit;
			}
		}
	}
}

function editBlock(inst)
{
	editing = inst;
	selected = noone;
}

function getCoord(val, a, b, tiles)
{
	return clamp(floor(tiles * invlerp(a, b, val)), 0, tiles - 1);
}

function arrangeUIInstances()
{
	for(var i = 0; i < instance_number(objProperty); i++)
	{
		with(instance_find(objProperty, i))
		{
			x = room_width - 16;
			y = 16 + 40 * i;
			update(objEditor.propertiesOf);
		}
	}
	
	for(var i = 0; i < instance_number(objButton); i++)
	{
		with(instance_find(objButton, i))
		{
			x = 16;
			y = 16 + 40 * i;
		}
	}
}

function selectInstance(inst, xSel = 0, ySel = 0)
{
	if (inst == noone)
	{
		selected = noone;
		editing.createProperties();
	}
	else
	{
		selected = inst;
		selectedTimer = 0;
		dragging = true;
		dragX = xSel;
		dragY = ySel;
		
		selected.createProperties();
	}
}

function destroyProperties()
{
	with(objProperty)
	{
		instance_destroy();
	}
}

function showPropertiesOf(inst)
{
	objEditor.propertiesOf = inst;
}

function findBlockByIndex(targetIndex)
{
	with(objBlock)
	{
		if (index == targetIndex)
		{
			return id;
		}
	}
	return noone;
}

function highlightIfSelected(rect)
{
	if (objEditor.selected == id)
	{
		draw_set_alpha(0.15 * (1-dcos(objEditor.selectedTimer * 360/60)));
		draw_set_color(c_white);
		drawRect(rect, false);
		draw_set_alpha(1);
	}
}

function incrementBlockWidth(inst)
{
	if (inst.width < global.maxBlockSize)
	{
		inst.width += 1;
		ds_grid_resize(inst.children, inst.width, inst.height);
		
		for(var i = 0; i < inst.height; i++)
		{
			inst.children[# inst.width - 1, i] = noone;
		}
		unsavedChanges = true;
	}
}

function incrementBlockHeight(inst)
{
	if (inst.height < global.maxBlockSize)
	{
		inst.height += 1;
		ds_grid_resize(inst.children, inst.width, inst.height);
		
		for(var i = 0; i < inst.width; i++)
		{
			inst.children[# i, inst.height - 1] = noone;
		}
		unsavedChanges = true;
	}
}

function decrementBlockWidth(inst)
{
	if (inst.width > global.minBlockSize)
	{
		if (inst.width > 1)
		{
			inst.width -= 1;
			ds_grid_resize(inst.children, inst.width, inst.height);
		}
		unsavedChanges = true;
	}
}

function decrementBlockHeight(inst)
{
	if (inst.height > global.minBlockSize)
	{
		if (inst.height > 1)
		{
			inst.height -= 1;
			ds_grid_resize(inst.children, inst.width, inst.height);
		}
		unsavedChanges = true;
	}
}

function resizeBlock(block, newWidth, newHeight)
{
	newWidth = clamp(newWidth, global.minBlockSize, global.maxBlockSize);
	newHeight = clamp(newHeight, global.minBlockSize, global.maxBlockSize);
	
	while(block.width < newWidth)
	{
		incrementBlockWidth(block);
	}
	while(block.height < newHeight)
	{
		incrementBlockHeight(block);
	}
	
	while(block.width > newWidth)
	{
		decrementBlockWidth(block);
	}
	while(block.height > newHeight)
	{
		decrementBlockHeight(block);
	}
}

function saveMap(editor, filePath)
{
	if (filePath == "")
	{
		filePath = get_save_filename_ext("Text file|*.txt", "level.txt", @"%appdata%\..\LocalLow\Patrick Traynor\Patrick's Parabox\custom_levels\", "Save Level As");
		editor.filePath = filePath;
	}
	if (filePath != "")
	{
		var file = file_text_open_write(filePath);
		file_text_write_string(file, editor.level.serialize());
		file_text_close(file);
		editor.unsavedChanges = false;
	}
}

function loadMap(editor)
{
	var filePath = get_open_filename_ext("Text file|*.txt", "", @"%appdata%\..\LocalLow\Patrick Traynor\Patrick's Parabox\custom_levels\", "Load Level");
	if (filePath != "")
	{
		editor.level.parse(fileToString(filePath));
		editor.editing = editor.level.block;
		editor.selected = noone;
		editor.editing.createProperties();
	}
}

function findFreeIndex(inst)
{
	var targetIndex = -1;
	do
	{
		targetIndex++;
		var exists = false;
		with(objBlock)
		{
			if (id != inst && index == targetIndex)
			{
				exists = true;
			}
		}
	}
	until (!exists)
	return targetIndex;
}

function dragInstance(rect)
{
	var xSel = getCoord(mouse_x, rect.x1, rect.x2, editing.width);
	var ySel = getCoord(mouse_y, rect.y1, rect.y2, editing.height);
	if ((xSel != dragX || ySel != dragY) && editing.children[# xSel, ySel] == noone)
	{
		editing.children[# xSel, ySel] = editing.children[# dragX, dragY];
		editing.children[# dragX, dragY] = noone;
		dragX = xSel;
		dragY = ySel;
		unsavedChanges = true;
	}
}

function serializeButtonBelow(type, indent, xx, yy)
{
	if (type != FLOOR.NONE)
	{
		var flr = instance_create_layer(0, 0, "Level", objFloor);
		flr.type = type;
		var str = flr.serialize(indent, xx, yy);
		instance_destroy(flr);
		return str;
	}
	else
	{
		return "";
	}
}

function createButtons()
{
	with(instance_create_layer(0, 0, "UI", objButton))
	{
		name = "New level";
		click = function()
		{
			game_restart();
		}
	}
	with(instance_create_layer(0, 0, "UI", objButton))
	{
		name = "Save level";
		click = function()
		{
			saveMap(objEditor, objEditor.filePath);
		}
		tooltip = "(Ctrl+S)";
	}
	with(instance_create_layer(0, 0, "UI", objButton))
	{
		name = "Save level as";
		click = function()
		{
			objEditor.filePath = "";
			saveMap(objEditor, objEditor.filePath);
		}
	}
	with(instance_create_layer(0, 0, "UI", objButton))
	{
		name = "Load level";
		click = function()
		{
			loadMap(objEditor);
		}
	}
	with(instance_create_layer(0, 0, "UI", objButton))
	{
		name = "Edit level properties";
		click = function()
		{
			with(objEditor)
			{
				selectInstance(level);
				frameDelay = true;
			}
		}
		tooltip = "(`)";
	}
	with(instance_create_layer(0, 0, "UI", objButton))
	{
		name = "Place Block";
		click = function()
		{
			with(objEditor)
			{
				tool = TOOL.PLACEBLOCK;
				frameDelay = true;
			}
		}
		tooltip = "(1)";
	}
	with(instance_create_layer(0, 0, "UI", objButton))
	{
		name = "Place Reference";
		click = function()
		{
			with(objEditor)
			{
				tool = TOOL.PLACEREF;
				frameDelay = true;
			}
		}
		tooltip = "(2)";
	}
	with(instance_create_layer(0, 0, "UI", objButton))
	{
		name = "Place Floor";
		click = function()
		{
			with(objEditor)
			{
				tool = TOOL.PLACEFLOOR;
				frameDelay = true;
			}
		}
		tooltip = "(3)";
	}
	with(instance_create_layer(0, 0, "UI", objButton))
	{
		name = "Delete";
		click = function()
		{
			with(objEditor)
			{
				if (instance_exists(selected) && selected.object_index != objLevel)
				{
					removeInstance(selected, true);
					selectInstance(noone);
				}
			}
		}
		tooltip = "(Delete/Shift + Right click)";
	}
	with(instance_create_layer(0, 0, "UI", objButton))
	{
		name = "Copy";
		click = function()
		{
			with(objEditor)
			{
				if (selected != noone && selected.object_index != objLevel)
				{
					copyInstance(selected);
				}
			}
		}
		tooltip = "(Ctrl+C)";
	}
	with(instance_create_layer(0, 0, "UI", objButton))
	{
		name = "Cut";
		click = function()
		{
			with(objEditor)
			{
				if (selected != noone && selected.object_index != objLevel)
				{
					cutInstance(selected);
				}
			}
		}
		tooltip = "(Ctrl+X)";
	}
	with(instance_create_layer(0, 0, "UI", objButton))
	{
		name = "Paste";
		click = function()
		{
			with(objEditor)
			{
				if (clipboard != noone)
				{
					tool = TOOL.PASTE;
					frameDelay = true;
				}
			}
		}
		tooltip = "(Ctrl+V)";
	}
}

function populateAttemptOrderFromString(list, str)
{
	var order = stringSplit(str, ",");
	ds_list_clear(list);
	if (array_length(order) == 4)
	{
		for(var i = 0; i < 4; i++)
		{
			switch(order[i])
			{
				case "push":
					ds_list_add(list, ATTEMPTORDER.PUSH);
					break;
				case "enter":
					ds_list_add(list, ATTEMPTORDER.ENTER);
					break;
				case "eat":
					ds_list_add(list, ATTEMPTORDER.EAT);
					break;
				case "possess":
					ds_list_add(list, ATTEMPTORDER.POSSESS);
					break;
			}
		}
	}
}
