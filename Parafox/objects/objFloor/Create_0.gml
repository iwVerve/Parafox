owner = noone;

type = FLOOR.BUTTON;

serialize = function(indent, xx, yy)
{
	var str = "";
	str += string_repeat("\t", indent);
	
	str += "Floor";
	str += " " + string(xx);
	str += " " + string(yy);
	
	var tStr;
	switch(type)
	{
		case FLOOR.BUTTON: tStr = "Button"; break;
		case FLOOR.PLAYERBUTTON: tStr = "PlayerButton"; break;
	}
	str += " " + tStr;
	
	return str;
}

parse = function(str)
{
	var args = string_split(str, " ");
	
	switch(remove_trailing_newlines(args[3]))
	{
		case "Button":
			type = FLOOR.BUTTON;
			break;
		case "PlayerButton":
			type = FLOOR.PLAYERBUTTON;
			break;
	}
	
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
			value = (inst.type == FLOOR.BUTTON) ? "Button" : "Player Button";
		}
		click = function(inst)
		{
			if (inst.type == FLOOR.BUTTON)
			{
				inst.type = FLOOR.PLAYERBUTTON;
			}
			else
			{
				inst.type = FLOOR.BUTTON;
			}
		}
	}
	focusProperties(id);
}

draw = function(x1, y1, x2, y2, level)
{
	draw_set_alpha(0.75);
	draw_set_color(c_white);
	
	if (type == FLOOR.BUTTON)
	{
		draw_sprite_pos(sprDecoration, 1, x1, y1, x2, y1, x2, y2, x1, y2, 0.75);
	}
	else
	{
		draw_sprite_pos(sprDecoration, 0, x1, y1, x2, y1, x2, y2, x1, y2, 0.75);
	}
	
	draw_set_alpha(1);
	
	highlightIfSelected(x1, y1, x2, y2);
}
