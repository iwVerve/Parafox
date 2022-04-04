owner = noone;

index = findFreeIndex(id);
width = 5;
height = 5;

hue = 0.6;
sat = 0.8;
val = 1;

zoomFactor = 1;

fillWithWalls = false;
player = false;
possessable = false;
playerOrder = 0;
flipH = false;
floatInSpace = false;
specialEffect = 0;

placedOn = FLOOR.NONE;

children = ds_grid_create(width, height);
ds_grid_clear(children, noone);

serialize = function(indent, xx, yy)
{
	var str = "";
	str += serializeSelf(indent, xx, yy);
	str += serializeChildren(indent);
	str += serializeButtonBelow(placedOn, indent, xx, yy);
	str = remove_trailing_newlines(str);
	return str;
}

serializeSelf = function(indent, xx, yy)
{
	var str = "";
	str += string_repeat("\t", indent);
	str += "Block";
	str += " " + string(xx);
	str += " " + string(yy);
	str += " " + string(index);
	str += " " + string(width);
	str += " " + string(height);
	str += " " + string(hue);
	str += " " + string(sat);
	str += " " + string(val);
	str += " " + string(zoomFactor);
	str += " " + ((fillWithWalls) ? "1" : "0");
	str += " " + ((player) ? "1" : "0");
	str += " " + ((possessable) ? "1" : "0");
	str += " " + string(playerOrder);
	str += " " + ((flipH) ? "1" : "0");
	str += " " + ((floatInSpace) ? "1" : "0");
	str += " " + string(specialEffect);
	str += "\n"
	
	return str;
}

serializeChildren = function(indent)
{
	var str = "";
	
	for(var i = 0; i < width; i++)
	{
		for(var j = 0; j < height; j++)
		{
			var inst = children[# i, j];
			if (!is_undefined(inst) && instance_exists(inst))
			{
				str += inst.serialize(indent + 1, i, j);
				str += "\n";
			}
		}
	}
	
	return str;
}

parse = function(array)
{
	parseSelf(array[0]);
	parseChildren(array);
}

parseSelf = function(str)
{
	var args = string_split(str, " ");
	
	if (real(args[1]) != -1)
	{
		var xx = real(args[1]);
		var yy = real(args[2]);
		var inst = owner.children[# xx, yy];
		if (inst != noone && inst.object_index == objButton)
		{
			placedOn = inst.type;
		}
		owner.children[# xx, yy] = id;
	}
	
	index = real(args[3]);
	width = real(args[4]);
	height = real(args[5]);
	
	hue = real(args[6]);
	sat = real(args[7]);
	val = real(args[8]);
	
	zoomFactor = real(args[9]);
	fillWithWalls = bool(args[10]);
	player = bool(args[11]);
	possessable = bool(args[12]);
	playerOrder = real(args[13]);
	flipH = bool(args[14]);
	floatInSpace = bool(args[15]);
	specialEffect = real(args[16]);
	
	ds_grid_resize(children, width, height);
	ds_grid_clear(children, noone);
}

parseChildren = function(array)
{
	var indent = count_tabs(array[0]);
	for(var i = 1; i < array_length(array); i++)
	{
		if (count_tabs(array[i]) == indent + 1)
		{
			var type = remove_leading_tabs(string_split(array[i], " ")[0]);
			switch(type)
			{
				case "Block":
					var block = instance_create_layer(0, 0, "Level", objBlock);
					block.owner = id;
					
					var index = i + 1;
					while(index < array_length(array) && count_tabs(array[index]) > indent + 1)
					{
						index++;
					}
					index--;
					var blockArgs = array_create(index - i + 1);
					array_copy(blockArgs, 0, array, i, index - i + 1);
					
					block.parse(blockArgs)
					break;
				case "Ref":
					var ref = instance_create_layer(0, 0, "Level", objRef);
					ref.owner = id;
					ref.parse(array[i]);
					break;
				case "Wall":
					var wall = instance_create_layer(0, 0, "Level", objWall);
					wall.owner = id;
					wall.parse(array[i]);
					break;
				case "Floor":
					var flr = instance_create_layer(0, 0, "Level", objFloor);
					flr.owner = id;
					flr.parse(array[i]);
					break;
			}
		}
	}
}

createProperties = function()
{
	destroyProperties();
	with(instance_create_layer(0, 0, "UI", objProperty))
	{
		name = "Index";
		update = function(inst)
		{
			value = inst.index;
		}
		click = function(inst)
		{
			inst.index = max(floor(get_integer("Enter new index", "")), 0);
		}
		tooltip = "Index of this block. Used by References."
	}
	with(instance_create_layer(0, 0, "UI", objProperty))
	{
		name = "Width";
		update = function(inst)
		{
			value = inst.width;
		}
		click = function(inst)
		{
			var w = clamp(floor(get_integer("Enter new width", "")), 1, 99);
			resizeBlock(inst, w, inst.height);
		}
		tooltip = "(+/-)";
	}
	with(instance_create_layer(0, 0, "UI", objProperty))
	{
		name = "Height";
		update = function(inst)
		{
			value = inst.height;
		}
		click = function(inst)
		{
			var h = clamp(floor(get_integer("Enter new height", "")), 1, 99);
			resizeBlock(inst, inst.width, h);
		}
		tooltip = "(+/-)";
	}
	with(instance_create_layer(0, 0, "UI", objProperty))
	{
		name = "Hue";
		update = function(inst)
		{
			value = inst.hue;
		}
		click = function(inst)
		{
			inst.hue = clamp(get_integer("Enter new hue", ""), 0, 1);
		}
	}
	with(instance_create_layer(0, 0, "UI", objProperty))
	{
		name = "Saturation";
		update = function(inst)
		{
			value = inst.sat;
		}
		click = function(inst)
		{
			inst.sat = clamp(get_integer("Enter new saturation", ""), 0, 1);
		}
	}
	with(instance_create_layer(0, 0, "UI", objProperty))
	{
		name = "Value";
		update = function(inst)
		{
			value = inst.val;
		}
		click = function(inst)
		{
			inst.val = clamp(get_integer("Enter new value", ""), 0, 1);
		}
	}
	with(instance_create_layer(0, 0, "UI", objProperty))
	{
		name = "Zoom Factor";
		update = function(inst)
		{
			value = inst.zoomFactor;
		}
		click = function(inst)
		{
			inst.zoomFactor = clamp(get_integer("Enter new zoom factor", ""), 0.1, 10);
		}
	}
	with(instance_create_layer(0, 0, "UI", objProperty))
	{
		name = "Fill with walls";
		update = function(inst)
		{
			value = (inst.fillWithWalls) ? "X" : " ";
		}
		click = function(inst)
		{
			inst.fillWithWalls = !inst.fillWithWalls;
		}
	}
	with(instance_create_layer(0, 0, "UI", objProperty))
	{
		name = "Player";
		update = function(inst)
		{
			value = (inst.player) ? "X" : " ";
		}
		click = function(inst)
		{
			inst.player = !inst.player;
		}
	}
	with(instance_create_layer(0, 0, "UI", objProperty))
	{
		name = "Possessable";
		update = function(inst)
		{
			value = (inst.possessable) ? "X" : " ";
		}
		click = function(inst)
		{
			inst.possessable = !inst.possessable;
		}
	}
	with(instance_create_layer(0, 0, "UI", objProperty))
	{
		name = "Player order";
		update = function(inst)
		{
			value = inst.playerOrder;
		}
		click = function(inst)
		{
			inst.playerOrder = clamp(floor(get_integer("Enter new player order", "")), 0, 50);
		}
	}
	with(instance_create_layer(0, 0, "UI", objProperty))
	{
		name = "Flip";
		update = function(inst)
		{
			value = (inst.flipH) ? "X" : " ";
		}
		click = function(inst)
		{
			inst.flipH = !inst.flipH;
		}
	}
	with(instance_create_layer(0, 0, "UI", objProperty))
	{
		name = "Float In Space";
		update = function(inst)
		{
			value = (inst.floatInSpace) ? "X" : " ";
		}
		click = function(inst)
		{
			inst.floatInSpace = !inst.floatInSpace;
		}
		tooltip = "Makes the block not actually present at this location. Instead, it's only accessible from References";
	}
	with(instance_create_layer(0, 0, "UI", objProperty))
	{
		name = "Special effect";
		update = function(inst)
		{
			value = inst.specialEffect;
		}
		click = function(inst)
		{
			inst.playerOrder = max(floor(get_integer("Enter new special effect", "")), 0);
		}
		tooltip = "Magic number used to flag blocks in various situations.";
	}
	with(instance_create_layer(0, 0, "UI", objProperty))
	{
		name = "Placed on";
		update = function(inst)
		{
			switch(inst.placedOn)
			{
				case FLOOR.NONE: value = ""; break;
				case FLOOR.BUTTON: value = "Button"; break;
				case FLOOR.PLAYERBUTTON: value = "Player Button"; break;
			}
		}
		click = function(inst)
		{
			inst.placedOn++;
			if (inst.placedOn > FLOOR.PLAYERBUTTON)
			{
				inst.placedOn = FLOOR.NONE;
			}
		}
	}
	focusProperties(id);
}

draw = function(x1, y1, x2, y2, level)
{
	if (flipH)
	{
		var temp = x1;
		x1 = x2;
		x2 = temp;
	}
	
	if (!fillWithWalls)
	{
		draw_set_color(make_color_pat(hue, sat, val/2));
	}
	else
	{
		draw_set_color(make_color_pat(hue, sat, val));
	}
	draw_rectangle(x1, y1, x2, y2, false);
	
	draw_set_color(c_black);
	if (!fillWithWalls)
	{
		for(var i = 0; i <= width; i++)
		{
			var xx = lerp(x1, x2, i/width);
			draw_line_fixed(xx, y1, xx, y2);
		}
		for(var i = 0; i <= height; i++)
		{
			var yy = lerp(y1, y2, i/height);
			draw_line_fixed(x1, yy, x2, yy);
		}
	}
	else
	{
		draw_rectangle(x1+1, y1+1, x2-1, y2-1, true);
	}
	
	if (!fillWithWalls && (level < global.depthLimit) && (min(abs(x2 - x1), abs(y2 - y1)) > global.sizeLimit))
	{
		for(var i = 0; i < width; i++)
		{
			for(var j = 0; j < height; j++)
			{
				var inst = children[# i, height - j - 1];
				if (!is_undefined(inst) && instance_exists(inst))
				{
					var xx1 = lerp(x1, x2, i/width);
					var xx2 = lerp(x1, x2, (i+1)/width);
					var yy1 = lerp(y1, y2, j/height);
					var yy2 = lerp(y1, y2, (j+1)/height);
					inst.draw(xx1, yy1, xx2, yy2, level+1);
				}
			}
		}
	}
	
	if (player)
	{
		draw_sprite_pos(sprDecoration, 3, x1, y1, x2, y1, x2, y2, x1, y2, 0.75);
	}
	else if (possessable)
	{
		draw_sprite_pos(sprDecoration, 2, x1, y1, x2, y1, x2, y2, x1, y2, 0.75);
	}
	
	highlightIfSelected(x1, y1, x2, y2);
}
