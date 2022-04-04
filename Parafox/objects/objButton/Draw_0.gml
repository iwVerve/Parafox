draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_font(fntProperty);

draw_text(x, y, name);

if(hover)
{
	draw_set_alpha(0.25);
	var m = 2;
	draw_rectangle(x - m, y - m, x + m + string_width(name), y + m + string_height(name), false);
	draw_set_alpha(1);
}
