draw_set_halign(fa_right);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_font(fntProperty);

var str = name + " [" + string(value) + "]";

draw_text(x, y, str);

if(hover)
{
	draw_set_alpha(0.25);
	var m = 2;
	draw_rectangle(x + m, y - m, x - m - string_width(str), y + m + string_height(str), false);
	draw_set_alpha(1);
}
