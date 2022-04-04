owner = noone;

index = 0;

exitblock = false;
infexit = false;
infexitnum = 0;
infenter = false;
infenternum = 0;
infenterid = -1;


player = false;
possessable = false;
playerOrder = 0;
flipH = false;
floatInSpace = false;
specialEffect = 0;

placedOn = FLOOR.NONE;

serialize = function(indent, xx, yy)
{
	var str = "";
	str += string_repeat("\t", indent);
	str += "Ref";
	
	str += " " + string(xx);
	str += " " + string(yy);
	str += " " + string(index);
	
	str += " " + ((exitblock) ? "1" : "0");
	str += " " + ((infexit) ? "1" : "0");
	str += " " + string(infexitnum);
	str += " " + ((infenter) ? "1" : "0");
	str += " " + string(infenternum);
	str += " " + string(infenterid);
	
	str += " " + ((player) ? "1" : "0");
	str += " " + ((possessable) ? "1" : "0");
	str += " " + string(playerOrder);
	str += " " + ((flipH) ? "1" : "0");
	str += " " + ((floatInSpace) ? "1" : "0");
	str += " " + string(specialEffect);
	
	if (placedOn != FLOOR.NONE)
	{
		str += "\n";
	}
	str += serializeButtonBelow(placedOn, indent, xx, yy);
	
	return str;
}

parse = function(str)
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
	
	exitblock = bool(args[4]);
	infexit = bool(args[5]);
	infexitnum = real(args[6]);
	infenter = bool(args[7]);
	infenternum = real(args[8]);
	infenterid = real(args[9]);
	
	player = bool(args[10])
	possessable = bool(args[11]);
	playerOrder = real(args[12]);
	flipH = bool(args[13]);
	floatInSpace = bool(args[14]);
	specialEffect = real(args[15]);
}

createProperties = function()
{
	destroyProperties();
	with(instance_create_layer(0, 0, "UI", objProperty))
	{
		name = "Index";
		update = function(inst)
		{
			if (objEditor.tool != TOOL.LINKREF)
			{
				value = inst.index;
			}
			else
			{
				value = "?";
			}
		}
		click = function(inst)
		{
			inst.index = max(floor(get_integer("Enter new index", "")), 0);
		}
		rightClick = function(inst)
		{
			objEditor.tool = TOOL.LINKREF;
			objEditor.frameDelay = true;
		}
		tooltip = "Index of Block to reference. Right click to set directly.";
	}
	with(instance_create_layer(0, 0, "UI", objProperty))
	{
		name = "Exit Block";
		update = function(inst)
		{
			value = (inst.exitblock) ? "X" : " ";
		}
		click = function(inst)
		{
			inst.exitblock = !inst.exitblock;
		}
		tooltip = "Allows infinite nesting in both directions.";
	}
	with(instance_create_layer(0, 0, "UI", objProperty))
	{
		name = "Infinite Exit";
		update = function(inst)
		{
			value = (inst.infexit) ? "X" : " ";
		}
		click = function(inst)
		{
			inst.infexit = !inst.infexit;
		}
		tooltip = "Makes the Reference an Infinity block."
	}
	with(instance_create_layer(0, 0, "UI", objProperty))
	{
		name = "Infinite Exit Num.";
		update = function(inst)
		{
			value = inst.infexitnum;
		}
		click = function(inst)
		{
			inst.infexitnum = max(floor(get_integer("Enter new infinite exit num.", "")), 0);
		}
		tooltip = "0 = 1 infinity.";
	}
	with(instance_create_layer(0, 0, "UI", objProperty))
	{
		name = "Infinite Enter";
		update = function(inst)
		{
			value = (inst.infenter) ? "X" : " ";
		}
		click = function(inst)
		{
			inst.infenter = !inst.infenter;
		}
		tooltip = "Makes the Reference an Epsilon block.";
	}
	with(instance_create_layer(0, 0, "UI", objProperty))
	{
		name = "Infinite Enter Num.";
		update = function(inst)
		{
			value = inst.infenternum;
		}
		click = function(inst)
		{
			inst.infenternum = max(floor(get_integer("Enter new infinite enter num.", "")), 0);
		}
		tooltip = "0 = 1 epsilon.";
	}
	with(instance_create_layer(0, 0, "UI", objProperty))
	{
		name = "Infinite Enter Index";
		update = function(inst)
		{
			value = inst.infenterid;
		}
		click = function(inst)
		{
			inst.infenterid = max(floor(get_integer("Enter new infinite enter index", "")), -1);
		}
		tooltip = "Gets entered from an infinite enter, 0 being 1 level of recursion. Exit Block is recommended.";
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
	
	with(findIndex(index))
	{
		draw(x1, y1, x2, y2, level+1);
	}
	
	draw_set_alpha(0.5);
	draw_set_color(c_white);
	draw_rectangle(x1, y1, x2, y2, false);
	draw_set_alpha(1);
	
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
