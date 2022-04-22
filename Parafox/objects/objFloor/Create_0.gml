owner = noone;

type = FLOOR.BUTTON;
infoText = "Hello_World";

serialize = function(indent, xx, yy)
{
	var str = "";
	str += string_repeat("\t", indent);
	
	str += "Floor";
	str += " " + string(xx);
	str += " " + string(yy);
	
	str += " " + getFloorNameFromType(type);
	if (type == FLOOR.INFO)
	{
		str += " " + infoText;
	}
	
	return str;
}

parse = function(str)
{
	var args = stringSplit(str, " ");
	
	type = getFloorTypeFromName(removeTrailingNewlines(args[3]));
	if (type = FLOOR.INFO)
	{
		infoText = args[4];
	}
		
	if (real(args[1]) != -1)
	{
		var xx = real(args[1]);
		var yy = real(args[2]);
		var inst = owner.children[# xx, yy];
		if (inst != noone && inst.object_index != objButton)
		{
			inst.placedOn = type;
			if (type == FLOOR.INFO)
			{
				inst.placedOnInfoText = infoText;
			}
			instance_destroy();
		}
		else
		{
			owner.children[# xx, yy] = id;
		}
	}
}

createProperties = function()
{
	destroyProperties();
	with(instance_create_layer(0, 0, "UI", objProperty))
	{
		name = "Type";
		update = function(inst)
		{
			value = getFloorNameFromType(inst.type);
		}
		click = function(inst)
		{
			inst.type++;
			if (inst.type >= FLOOR.NUMBER)
			{
				inst.type -= FLOOR.NUMBER - 1; //Don't go all the way to None
			}
		}
	}
	with(instance_create_layer(0, 0, "UI", objProperty))
	{
		name = "Text";
		update = function(inst)
		{
			value = inst.infoText;
			visible = (inst.type == FLOOR.INFO);
		}
		click = function(inst)
		{
			var str = get_string("Enter text of info tile (\\n for a new line)", "");
			while(string_pos(" ", str) != 0)
			{
				str = string_replace(str, " ", "_");
			}
			inst.infoText = str;
		}
	}
	showPropertiesOf(id);
}

draw = function(rect, level)
{
	draw_set_alpha(0.75);
	draw_set_color(c_white);
	
	drawSpriteRect(getFloorSpriteFromType(type), 0, rect, 0.75);
	
	draw_set_alpha(1);
	
	highlightIfSelected(rect);
}
