function stringSplit(str, char)
{
	array = array_create(0);
	while(string_pos(char, str) != 0)
	{
		var index = string_pos(char, str);
		array_push(array, removeSurroundingNewlines(string_copy(str, 1, index - 1)));
		str = string_delete(str, 1, index);
	}
	array_push(array, removeSurroundingNewlines(str));
	
	return array;
}

function countLeadingTabs(str)
{
	var count = 1;
	while(string_char_at(str, count) == "\t")
	{
		count++;
	}
	return count - 1;
}

function removeLeadingTabs(str)
{
	while(string_char_at(str, 1) == "\t")
	{
		str = string_delete(str, 1, 1);
	}
	return str;
}

function removeTrailingNewlines(str)
{
	var c = string_char_at(str, string_length(str));
	while(c == "\n" || c == "\r")
	{
		str = string_delete(str, string_length(str), 1);
		c = string_char_at(str, string_length(str));
	}
	return str;
}

function removeLeadingNewlines(str)
{
	var c = string_char_at(str, 1);
	while(c == "\n" || c == "\r")
	{
		str = string_delete(str, 1, 1);
		c = string_char_at(str, string_length(str));
	}
	return str;
}

function removeSurroundingNewlines(str)
{
	return removeLeadingNewlines(removeTrailingNewlines(str));
}

function makeColorPat(hue, sat, val)
{
	return make_color_hsv(255 * hue, 255 * sat, 255 * val);
}

function drawLineFixed(x1, y1, x2, y2)
{
	draw_point(x1, y1);
	draw_line(x1, y1, x2, y2);
	draw_point(x2, y2);
}

function destroyLevelInstances()
{
	with(objBlock) {instance_destroy();}
	with(objRef) {instance_destroy();}
	with(objWall) {instance_destroy();}
	with(objFloor) {instance_destroy();}
}

function invlerp(a, b, val)
{
	return (val - a) / (b - a);
}

function inRange(val, a, b)
{
	return val == median(val, a, b);
}

function fileToString(filePath)
{
	var str = "";
	var file = file_text_open_read(filePath);
	while(!file_text_eof(file))
	{
		str += file_text_readln(file);
	}
	file_text_close(file);
	
	return str;
}

function getAttemptOrderString(attemptOrder, sep)
{
	var str = "";
	for(var i = 0; i < ds_list_size(attemptOrder); i++)
	{
		if (i > 0)
		{
			str += sep;
		}
		switch(attemptOrder[| i])
		{
			case ATTEMPTORDER.PUSH:
				str += "push";
				break;
			case ATTEMPTORDER.ENTER:
				str += "enter";
				break;
			case ATTEMPTORDER.EAT:
				str += "eat";
				break;
			case ATTEMPTORDER.POSSESS:
				str += "possess";
				break;
		}
	}
	return str;
}

function defineReal(num, def = 0)
{
	if (is_undefined(num))
	{
		return def;
	}
	return num;
}

function drawRect(rect, outline)
{
	draw_rectangle(rect.x1, rect.y1, rect.x2, rect.y2, outline);
}

function drawSpriteRect(sprite, subimg, rect, alpha)
{
	draw_sprite_pos(sprite, subimg, rect.x1, rect.y1, rect.x2, rect.y1, rect.x2, rect.y2, rect.x1, rect.y2, alpha);
}

function Rect(_x1, _y1, _x2, _y2) constructor
{
	x1 = _x1;
	y1 = _y1;
	x2 = _x2;
	y2 = _y2;
	
	clone = function()
	{
		return new Rect(x1, y1, x2, y2);
	}
	
	scale = function(size)
	{
		var xCenter = mean(x1, x2);
		var yCenter = mean(y1, y2);
		x1 = lerp(xCenter, x1, size);
		y1 = lerp(yCenter, y1, size);
		x2 = lerp(xCenter, x2, size);
		y2 = lerp(yCenter, y2, size);
	}
}

function drawTextOutlined(xx, yy, string, scale, fillColor, outlineColor)
{
	draw_set_color(outlineColor);
	for(var i = -1; i <= 1; i++)
	{
		for(var j = -1; j <= 1; j++)
		{
			if (i != 0 && j != 0)
			{
				draw_text_transformed(xx+i, yy+j, string, scale, scale, 0);
			}
		}
	}
	draw_set_color(fillColor);
	draw_text_transformed(xx, yy, string, scale, scale, 0);
}

function pointInRect(xx, yy, rect)
{
	return (inRange(xx, rect.x1, rect.x2) && inRange(yy, rect.y1, rect.y2));
}

function getColorName(color)
{
	switch(color)
	{
		case COLOR.A:
			return "Root";
		case COLOR.B:
			return "Block 1";
		case COLOR.C:
			return "Block 2";
		case COLOR.D:
			return "Push block";
		case COLOR.E:
			return "Player";
		case COLOR.F:
			return "Block 3";
	}
}

function drawSpritePosColor(sprite, index, x1, y1, x2, y2, x3, y3, x4, y4, color, alpha)
{
	var tex = sprite_get_texture(sprite, index);
	draw_primitive_begin_texture(pr_trianglestrip, tex);
		draw_vertex_texture_color(x1, y1, 0, 0, color, alpha);
		draw_vertex_texture_color(x2, y2, 1, 0, color, alpha);
		draw_vertex_texture_color(x4, y4, 0, 1, color, alpha);
		draw_vertex_texture_color(x3, y3, 1, 1, color, alpha);
	draw_primitive_end();
}

function drawSpriteRectColor(sprite, index, rect, color, alpha)
{
	drawSpritePosColor(sprite, index, rect.x1, rect.y1, rect.x2, rect.y1, rect.x2, rect.y2, rect.x1, rect.y2, color, alpha);
}

function instIsObject(inst, object)
{
	return (inst != noone && inst.object_index == object);
}
