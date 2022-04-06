draw_set_halign(fa_right);
draw_set_valign(fa_top);
draw_set_color(c_white);

var str = name + " [" + string(value) + "]";

draw_text_transformed(x, y, str, global.textScaleButton, global.textScaleButton, 0);

var w = global.textScaleButton * string_width(str);
var h = global.textScaleButton * string_height(str);

if(hover)
{
	draw_set_alpha(0.25);
	var m = global.buttonPadding;
	draw_rectangle(x + m, y - m, x - m - w, y + m + h, false);
	draw_set_alpha(1);
}
