owner = noone;

player = false;
possessable = false;
playerOrder = 0;

placedOn = FLOOR.NONE;

serialize = function(indent, xx, yy)
{
	var str = "";
	str += string_repeat("\t", indent);
	str += "Wall";
	str += " " + string(xx);
	str += " " + string(yy);
	str += " " + ((player) ? "1" : "0");
	str += " " + ((possessable) ? "1" : "0");
	str += " " + string(playerOrder);
	
	if (placedOn != FLOOR.NONE)
	{
		str += "\n";
	}
	str += serializeButtonBelow(placedOn, indent, xx, yy);
	return str;
}

parse = function(str)
{
	var args = stringSplit(str, " ");
	
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
	
	player = bool(args[3]);
	possessable = bool(args[4]);
	playerOrder = real(args[5]);
}

createProperties = function()
{
	destroyProperties();
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
			inst.playerOrder = clamp(floor(defineReal(get_integer("Enter new player order", ""))), 0, 50);
		}
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
	showPropertiesOf(id);
}

draw = function(rect, level)
{
	draw_set_color(makeColorPat(owner.hue, owner.sat, owner.val));
	drawRect(rect, false);
	
	if (player)
	{
		drawSpriteRect(sprDecoration, 3, rect, 0.75);
	}
	else if (possessable)
	{
		drawSpriteRect(sprDecoration, 2, rect, 0.75);
	}
	
	highlightIfSelected(rect);
}
