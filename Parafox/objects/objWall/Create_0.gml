owner = noone;

player = false;
possessable = false;
playerOrder = 0;

placedOn = FLOOR.NONE;
placedOnInfoText = "Hello_World";

imageIndex = 0;

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
	str += serializeButtonBelow(placedOn, indent, xx, yy, placedOnInfoText);
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
		if (instIsObject(inst, objButton))
		{
			placedOn = inst.type;
			if (placedOn == FLOOR.INFO)
			{
				placedOnInfoText = inst.infoText;
			}
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
			inst.playerOrder = clamp(floor(defineReal(get_integer("Enter new player order", ""), inst.playerOrder)), 0, global.maxPlayerOrder);
		}
	}
	with(instance_create_layer(0, 0, "UI", objProperty))
	{
		name = "Placed on";
		update = function(inst)
		{
			value = getFloorNameFromType(inst.placedOn);
		}
		click = function(inst)
		{
			inst.placedOn++;
			if (inst.placedOn >= FLOOR.NUMBER)
			{
				inst.placedOn -= FLOOR.NUMBER;
			}
		}
	}
	with(instance_create_layer(0, 0, "UI", objProperty))
	{
		name = "Text";
		update = function(inst)
		{
			value = inst.placedOnInfoText;
			visible = (inst.placedOn == FLOOR.INFO);
		}
		click = function(inst)
		{
			var str = get_string("Enter text of info tile (\\n for a new line)", "");
			while(string_pos(" ", str) != 0)
			{
				str = string_replace(str, " ", "_");
			}
			inst.placedOnInfoText = str;
		}
	}
	showPropertiesOf(id);
}

draw = function(rect, level)
{
	drawSpriteRectColor(sprWall, imageIndex, rect, makeColorPat(owner.hue, owner.sat, owner.val), 1);
	
	if (player)
	{
		drawSpriteRect(sprPlayer, 0, rect, 0.75);
	}
	else if (possessable)
	{
		drawSpriteRect(sprPossessable, 0, rect, 0.75);
	}
	
	highlightIfSelected(rect);
}
