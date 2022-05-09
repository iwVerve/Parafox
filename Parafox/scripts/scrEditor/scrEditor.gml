function removeInstance(inst, destroy)
{
	if (inst.object_index == objBlock)
	{
		with(objRef)
		{
			if (index == inst.index)
			{
				index = findTakenIndex(inst);
			}
		}
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
	if (!instIsObject(instOwner, objLevel))
	{
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
					updateWallIndexes(editing);
					exit;
				}
			}
		}
	}
	else
	{
		if (destroy)
		{
			instance_destroy(inst);
		}
		else
		{
			inst.owner = noone;
		}
		unsavedChanges = true;
		updateWallIndexes(editing);
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
	var offset = 0;
	for(var i = 0; i < instance_number(objProperty); i++)
	{
		with(instance_find(objProperty, i))
		{
			update(objEditor.propertiesOf);
			if (visible)
			{
				x = room_width - 16;
				y = 16 + offset;
				offset += global.buttonSpacing;
			}
		}
	}
	
	offset = 0;
	for(var i = 0; i < instance_number(objButton); i++)
	{
		with(instance_find(objButton, i))
		{
			update(objEditor);
			if (visible)
			{
				x = 16;
				y = 16 + offset;
				offset += global.buttonSpacing;
			}
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
		
		if (inst.object_index != objLevel)
		{
			dragging = true;
			dragX = xSel;
			dragY = ySel;
		}
		
		selected.createProperties();
	}
}

function deselectInstance()
{
	destroyProperties();
	selected = noone;
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
	dragging = false;
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
	dragging = false;
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
	dragging = false;
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
	dragging = false;
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
	dragging = false;
	
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
	if (global.saveMode == 0)
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
	else if (global.saveMode == 1)
	{
		clipboard_set_text(editor.level.serialize());
	}
}

function loadMap(editor)
{
	if (global.saveMode == 0)
	{
		var filePath = get_open_filename_ext("Text file|*.txt", "", @"%appdata%\..\LocalLow\Patrick Traynor\Patrick's Parabox\custom_levels\", "Load Level");
		if (filePath != "")
		{
			editor.level.parse(fileToString(filePath));
			editor.editing = editor.level.rootBlocks[| 0];
			editor.selected = noone;
			editor.editing.createProperties();
			editor.filePath = "";
		}
	}
	else if (global.saveMode == 1)
	{
		editor.level.parse(clipboard_get_text());
		editor.editing = editor.level.rootBlocks[| 0];
		editor.selected = noone;
		editor.editing.createProperties();
		editor.filePath = "";
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

function findTakenIndex(inst)
{
	with(objBlock)
	{
		if (id != inst)
		{
			return index;
		}
	}
	return 0;
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
		updateWallIndexes(editing);
	}
}

function serializeButtonBelow(type, indent, xx, yy, infoText = "")
{
	if (type != FLOOR.NONE)
	{
		var flr = instance_create_layer(0, 0, "Level", objFloor);
		flr.type = type;
		if (type == FLOOR.INFO)
		{
			flr.infoText = infoText;
		}
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
		name = "Undo";
		click = function()
		{
			with(objEditor)
			{
				undoAction(id);
			}
		}
		update = function()
		{
			name = "Undo (" + string(ds_list_size(objEditor.undoStack)) + ")";
		}
		tooltip = "(Ctrl+Z)";
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
		name = "Grid View";
		click = function()
		{
			with(objEditor)
			{
				view = EDITORVIEW.GRID;
				tool = TOOL.SELECT;
				frameDelay = true;
			}
		}
		update = function(editor)
		{
			visible = (editor.view == EDITORVIEW.EDIT);
		}
		tooltip = "(Tab)";
	}
	with(instance_create_layer(0, 0, "UI", objButton))
	{
		name = "Exit Grid View";
		click = function()
		{
			with(objEditor)
			{
				view = EDITORVIEW.EDIT;
				frameDelay = true;
			}
		}
		update = function(editor)
		{
			visible = (editor.view == EDITORVIEW.GRID);
		}
		tooltip = "(Tab)";
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
		update = function(editor)
		{
			visible = (editor.view == EDITORVIEW.EDIT);
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
		update = function(editor)
		{
			visible = (editor.view == EDITORVIEW.EDIT);
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
		update = function(editor)
		{
			visible = (editor.view == EDITORVIEW.EDIT);
		}
		tooltip = "(3)";
	}
	with(instance_create_layer(0, 0, "UI", objButton))
	{
		name = "Draw walls";
		click = function()
		{
			with(objEditor)
			{
				tool = TOOL.DRAWWALLS;
				frameDelay = true;
			}
		}
		update = function(editor)
		{
			visible = (editor.view == EDITORVIEW.EDIT);
		}
		tooltip = "(Shift + Click)";
	}
	with(instance_create_layer(0, 0, "UI", objButton))
	{
		name = "Paint Blocks";
		click = function()
		{
			with(objEditor)
			{
				if (tool != TOOL.PAINTBRUSH)
				{
					tool = TOOL.PAINTBRUSH;
				}
				else
				{
					paintBrushColor++;
					if (paintBrushColor >= COLOR.NUMBER)
					{
						paintBrushColor -= COLOR.NUMBER;
					}
				}
				frameDelay = true;
			}
		}
		update = function(editor)
		{
			name = "Paint Blocks"
			if (editor.tool == TOOL.PAINTBRUSH)
			{
				name += " [";
				name += getColorName(editor.paintBrushColor);
				name += "]";
			}
			visible = (editor.view == EDITORVIEW.EDIT);
		}
		tooltip = "Click again to cycle through colors."
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
		update = function(editor)
		{
			visible = (editor.view == EDITORVIEW.EDIT);
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
		update = function(editor)
		{
			visible = (editor.view == EDITORVIEW.EDIT);
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
		update = function(editor)
		{
			visible = (editor.view == EDITORVIEW.EDIT);
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
		update = function(editor)
		{
			visible = (editor.view == EDITORVIEW.EDIT);
		}
		tooltip = "(Ctrl+V)";
	}
	with(instance_create_layer(0, 0, "UI", objButton))
	{
		name = "Add root block";
		click = function()
		{
			with(objEditor)
			{
				var block = instance_create_layer(0, 0, "Level", objBlock);
				block.owner = level;
				ds_list_add(level.rootBlocks, block);
			}
		}
		update = function(editor)
		{
			visible = (editor.view == EDITORVIEW.GRID);
		}
	}
	with(instance_create_layer(0, 0, "UI", objButton))
	{
		name = "Delete block";
		click = function()
		{
			with(objEditor)
			{
				tool = TOOL.GRIDDELETE;
				frameDelay = true;
			}
		}
		update = function(editor)
		{
			visible = (editor.view == EDITORVIEW.GRID);
		}
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

function getFloorSpriteFromType(type)
{
	switch(type)
	{
		case FLOOR.BUTTON:
			return sprButton;
		case FLOOR.PLAYERBUTTON:
			return sprPlayerButton;
		case FLOOR.FASTTRAVEL:
			return sprFastTravel;
		case FLOOR.INFO:
			return sprInfo;
	}
}

function getFloorNameFromType(type)
{
	switch(type)
	{
		case FLOOR.BUTTON:
			return "Button";
		case FLOOR.PLAYERBUTTON:
			return "PlayerButton";
		case FLOOR.FASTTRAVEL:
			return "FastTravel";
		case FLOOR.INFO:
			return "Info";
		default:
			return "";
	}
}

function getFloorTypeFromName(name)
{
	switch(name)
	{
		case "Button":
			return FLOOR.BUTTON;
		case "PlayerButton":
			return FLOOR.PLAYERBUTTON;
		case "FastTravel":
			return FLOOR.FASTTRAVEL;
		case "Info":
			return FLOOR.INFO;
	}
}

function paintBlock(inst, col)
{
	switch(col)
	{
		case COLOR.A:
			inst.hue = 0.0;
			inst.sat = 0.0;
			inst.val = 0.8;
			break;
		case COLOR.B:
			inst.hue = 0.6;
			inst.sat = 0.8;
			inst.val = 1.0;
			break;
		case COLOR.C:
			inst.hue = 0.4;
			inst.sat = 0.8;
			inst.val = 1.0;
			break;
		case COLOR.D:
			inst.hue = 0.1;
			inst.sat = 0.8;
			inst.val = 1.0;
			break;
		case COLOR.E:
			inst.hue = 0.9;
			inst.sat = 1.0;
			inst.val = 0.7;
			break;
		case COLOR.F:
			inst.hue = 0.55;
			inst.sat = 0.8;
			inst.val = 1.0;
			break;
	}
}

function openConfig()
{
	ini_open("config.ini");
	
	global.saveMode = ini_read_real("main", "saveMode", 0);
	ini_write_real("main", "saveMode", global.saveMode);
	
	ini_close();
}
