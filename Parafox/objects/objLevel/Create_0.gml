attemptOrder = ds_list_create();
ds_list_add(attemptOrder, ATTEMPTORDER.PUSH);
ds_list_add(attemptOrder, ATTEMPTORDER.ENTER);
ds_list_add(attemptOrder, ATTEMPTORDER.EAT);
ds_list_add(attemptOrder, ATTEMPTORDER.POSSESS);

shed = false;
innerPush = false;
drawStyle = DRAWSTYLE.NORMAL;
music = -1;
palette = -1;

block = instance_create_layer(0, 0, "Level", objBlock);

serialize = function()
{
	var str = "";
	str += serializeHeader();
	str += block.serialize(0, -1, -1);
	return str;
}

serializeHeader = function()
{
	var str = "";
	str += "version 4\n";
	
	str += "attempt_order ";
	for(var i = 0; i < ds_list_size(attemptOrder); i++)
	{
		var aStr;
		switch(attemptOrder[| i])
		{
			case ATTEMPTORDER.PUSH:    aStr = "push"; break;
			case ATTEMPTORDER.ENTER:   aStr = "enter"; break;
			case ATTEMPTORDER.EAT:     aStr = "eat"; break;
			case ATTEMPTORDER.POSSESS: aStr = "possess"; break;
		}
		str += aStr;
		if (i < ds_list_size(attemptOrder) - 1)
		{
			str += ",";
		}
		else
		{
			str += "\n";
		}
	}
	
	if (shed)
	{
		str += "shed\n";
	}
	if (innerPush)
	{
		str += "inner_push\n";
	}
	
	if (drawStyle != DRAWSTYLE.NORMAL)
	{
		var dStr;
		switch(drawStyle)
		{
			case DRAWSTYLE.TUI:      dStr = "tui"; break;
			case DRAWSTYLE.GRID:     dStr = "grid"; break;
			case DRAWSTYLE.OLDSTYLE: dStr = "oldstyle"; break;
		}
		dStr += "draw_style " + dStr + "\n";
	}
	
	str += "custom_level_music " + string(music) + "\n";
	str += "custom_level_palette " + string(palette) + "\n";
	
	str += "#\n"
	
	return str;
}

parse = function(str)
{
	destroyLevelInstances();
	
	var index = string_pos("#", str);
	var header = removeSurroundingNewlines(string_copy(str, 1, index - 1));
	var body = removeSurroundingNewlines(string_copy(str, index + 2, string_length(str) - index));
	
	parseHeader(header);
	parseBody(body);
}

parseHeader = function(str)
{
	var lines = stringSplit(str, "\n");
	for(var i = 0; i < array_length(lines); i++)
	{
		var line = lines[i];
		var args = stringSplit(line, " ");
		switch(args[0])
		{
			case "version":
				if (args[1] != "4")
				{	
					show_message("incompatible file format");
					game_restart();
				}
				break;
			case "attempt_order":
				populateAttemptOrderFromString(attemptOrder, args[1]);
				break;
			case "shed":
				shed = true;
				break;
			case "inner_push":
				innerPush = true;
				break;
			case "draw_style":
				switch(args[1])
				{
					case "tui":      drawStyle = DRAWSTYLE.TUI; break;
					case "grid":     drawStyle = DRAWSTYLE.GRID; break;
					case "oldstyle": drawStyle = DRAWSTYLE.OLDSTYLE; break;
				}
				break;
			case "custom_level_music":
				music = real(args[1]);
				break;
			case "custom_level_palette":
				palette = real(args[1]);
				break;
		}
	}
}

parseBody = function(str)
{
	var lines = stringSplit(str, "\n");
	block = instance_create_layer(0, 0, "Level", objBlock);
	block.owner = id;
	block.parse(lines);
}

createProperties = function()
{
	destroyProperties();
	with(instance_create_layer(0, 0, "UI", objProperty))
	{
		name = "Extrude";
		update = function(inst)
		{
			value = (inst.shed) ? "X" : " ";
		}
		click = function(inst)
		{
			inst.shed = !inst.shed;
		}
		tooltip = "Enables behavior from the Extrude appendix area";
	}
	with(instance_create_layer(0, 0, "UI", objProperty))
	{
		name = "Inner push";
		update = function(inst)
		{
			value = (inst.innerPush) ? "X" : " ";
		}
		click = function(inst)
		{
			inst.innerPush = !inst.innerPush;
		}
		tooltip = "Enables behavior from the Inner push appendix area";
	}
	with(instance_create_layer(0, 0, "UI", objProperty))
	{
		name = "Draw style";
		update = function(inst)
		{
			switch(inst.drawStyle)
			{
				case DRAWSTYLE.NORMAL: value = "Normal"; break;
				case DRAWSTYLE.TUI: value = "Text"; break;
				case DRAWSTYLE.GRID: value = "Grid"; break;
				case DRAWSTYLE.OLDSTYLE: value = "Old"; break;
			}
		}
		click = function(inst)
		{
			inst.drawStyle += 1;
			if (inst.drawStyle > DRAWSTYLE.OLDSTYLE)
			{
				inst.drawStyle = DRAWSTYLE.NORMAL;
			}
		}
	}
	with(instance_create_layer(0, 0, "UI", objProperty))
	{
		name = "Music";
		update = function(inst)
		{
			value = inst.music;
		}
		click = function(inst)
		{
			inst.music = max(floor(defineReal(get_integer("Enter new music index", ""), inst.music)), -1);
		}
	}
	with(instance_create_layer(0, 0, "UI", objProperty))
	{
		name = "Palette index";
		update = function(inst)
		{
			value = inst.palette;
		}
		click = function(inst)
		{
			inst.palette = max(floor(defineReal(get_integer("Enter new palette index", ""), inst.palette)), -1);
		}
	}
	with(instance_create_layer(0, 0, "UI", objProperty))
	{
		name = "Attempt order";
		value = "...";
		click = function(inst)
		{
			var order = get_string("Enter new attempt order: enter digits 1-4 (each exactly once)\n1 = Push, 2 = Enter, 3 = Eat, 4 = Possess\nLeave empty for no change\nCurrent order: " + getAttemptOrderString(inst.attemptOrder, ", "), "");
			if (string_length(order) == 4 && string_pos("1", order) != 0 && string_pos("1", order) != 0 && string_pos("2", order) != 0 && string_pos("3", order) != 0 && string_pos("4", order) != 0)
			{
				ds_list_clear(inst.attemptOrder);
				for(var i = 1; i < 5; i++)
				{
					switch(string_char_at(order, i))
					{
						case "1":
							ds_list_add(inst.attemptOrder, ATTEMPTORDER.PUSH);
							break;
						case "2":
							ds_list_add(inst.attemptOrder, ATTEMPTORDER.ENTER);
							break;
						case "3":
							ds_list_add(inst.attemptOrder, ATTEMPTORDER.EAT);
							break;
						case "4":
							ds_list_add(inst.attemptOrder, ATTEMPTORDER.POSSESS);
							break;
					}
				}
			}
			else if (order != "")
			{
				show_message("Invalid order format");
			}
		}
	}
	showPropertiesOf(id);
}
