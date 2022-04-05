owner = noone;

type = FLOOR.BUTTON;

serialize = function(indent, xx, yy)
{
	var str = "";
	str += string_repeat("\t", indent);
	
	str += "Floor";
	str += " " + string(xx);
	str += " " + string(yy);
	
	str += " " + getFloorNameFromType(type);
	
	return str;
}

parse = function(str)
{
	var args = stringSplit(str, " ");
	
	type = getFloorTypeFromName(removeTrailingNewlines(args[3]));
		
	if (real(args[1]) != -1)
	{
		var xx = real(args[1]);
		var yy = real(args[2]);
		var inst = owner.children[# xx, yy];
		if (inst != noone && inst.object_index != objButton)
		{
			inst.placedOn = type;
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
