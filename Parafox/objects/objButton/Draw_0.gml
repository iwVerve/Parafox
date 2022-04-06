draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);

draw_text_transformed(x, y, name, global.textScaleButton, global.textScaleButton, 0);

var w = global.textScaleButton * string_width(name);
var h = global.textScaleButton * string_height(name);

if(hover)
{
	draw_set_alpha(0.25);
	var m = global.buttonPadding;
	draw_rectangle(x - m, y - m, x + m + w, y + m + h, false);
	draw_set_alpha(1);
}
