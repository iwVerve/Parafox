function checkClipboardControls(xSel, ySel)
{
	if (keyboard_check_pressed(ord("X")))
	{
		if (selected != noone && selected.object_index != objLevel)
		{
			cutInstance(selected);
		}
	}
	if (keyboard_check_pressed(ord("C")))
	{
		if (selected != noone && selected.object_index != objLevel)
		{
			copyInstance(selected);
		}
	}
	if (keyboard_check_pressed(ord("V")))
	{
		if (clipboard != noone)
		{
			var inst = pasteInstance(xSel, ySel);
			if (inst != noone)
			{
				selectInstance(inst);
			}
		}
	}
}

function copyInstance(inst)
{	
	clipboard = inst.serialize(0, -1, -1);
}

function cutInstance(inst)
{
	copyInstance(inst);
	removeInstance(inst, true);
	selectInstance(noone);
}

function pasteInstance(xx, yy)
{
	if (editing.children[# xx, yy] == noone)
	{
		unsavedChanges = true;
		switch(stringSplit(removeLeadingTabs(clipboard), " ")[0])
		{
			case "Block":
				var block = instance_create_layer(0, 0, "Level", objBlock);
				block.owner = editing;
				block.parse(stringSplit(clipboard, "\n"));
				block.index = findFreeIndex(block);
				editing.children[# xx, yy] = block;
				return block;
			case "Ref":
				var ref = instance_create_layer(0, 0, "Level", objRef);
				ref.owner = editing;
				ref.parse(clipboard);
				editing.children[# xx, yy] = ref;
				return ref;
			case "Wall":
				var wall = instance_create_layer(0, 0, "Level", objWall);
				wall.owner = editing;
				wall.parse(clipboard);
				editing.children[# xx, yy] = wall;
				updateWallIndexes(editing);
				return wall;
			case "Floor":
				var flr = instance_create_layer(0, 0, "Level", objFloor);
				flr.owner = editing;
				flr.parse(clipboard);
				editing.children[# xx, yy] = flr;
				return flr;
		}
	}
	return noone;
}
