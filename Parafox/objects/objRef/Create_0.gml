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
placedOnInfoText = "Hello_World";

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
			inst.index = floor(defineReal(get_integer("Enter new index", ""), inst.index));
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
			inst.infexitnum = max(floor(defineReal(get_integer("Enter new infinite exit num.", ""), inst.infexitnum)), 0);
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
			inst.infenternum = max(floor(defineReal(get_integer("Enter new infinite enter num.", ""), inst.infenternum)), 0);
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
			inst.infenterid = floor(defineReal(get_integer("Enter new infinite enter index", ""), inst.infenterid));
		}
		tooltip = "This epsilon block will get entered when performing an infinite enter into a block with this index.";
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
			inst.playerOrder = clamp(floor(defineReal(get_integer("Enter new player order", ""), inst.playerOrder)), 0, global.maxPlayerOrder);
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
			inst.specialEffect = max(floor(defineReal(get_integer("Enter new special effect", ""), inst.specialEffect)), 0);
		}
		tooltip = "Magic number used to flag blocks in various situations.";
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
	if (flipH)
	{
		var temp = rect.x1;
		rect.x1 = rect.x2;
		rect.x2 = temp;
	}
	
	with(findBlockByIndex(index))
	{
		draw(rect.clone(), level+1, false);
	}
	
	if (!exitblock)
	{
		draw_set_alpha(0.33);
		draw_set_color(c_white);
		drawRect(rect, false);
		draw_set_alpha(1);
	}
	
	if (infexit)
	{
		var xx1 = lerp(rect.x1, rect.x2, (1 - 1/(infexitnum + 1)) / 2);
		var xx2 = lerp(rect.x1, rect.x2, (1 + 1/(infexitnum + 1)) / 2);
		for (var i = 0; i < (infexitnum + 1); i++)
		{
			var yy1 = lerp(rect.y1, rect.y2, i / (infexitnum + 1));
			var yy2 = lerp(rect.y1, rect.y2, (i+1) / (infexitnum + 1));
			
			var infRect = new Rect(xx1, yy1, xx2, yy2);
			drawSpriteRect(sprInfinity, 0, infRect, 0.75);
		}
	}
	else if (infenter)
	{
		var xx1 = lerp(rect.x1, rect.x2, (1 - 1/(infenternum + 1)) / 2);
		var xx2 = lerp(rect.x1, rect.x2, (1 + 1/(infenternum + 1)) / 2);
		for (var i = 0; i < (infenternum + 1); i++)
		{
			var yy1 = lerp(rect.y1, rect.y2, i / (infenternum + 1));
			var yy2 = lerp(rect.y1, rect.y2, (i+1) / (infenternum + 1));
			
			var epsRect = new Rect(xx1, yy1, xx2, yy2);
			drawSpriteRect(sprEpsilon, 0, epsRect, 0.75);
		}
	}
	
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
