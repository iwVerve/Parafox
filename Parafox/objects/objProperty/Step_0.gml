draw_set_font(fntProperty);
var str = name + " [" + string(value) + "]";

var m = 2;
if (inRange(mouse_x, x + m, x - m - string_width(str)) && inRange(mouse_y, y - m, y + m + string_height(str)))
{
	hover = true;
	if (mouse_check_button_pressed(mb_left))
	{
		click(objEditor.propertiesOf);
		objEditor.unsavedChanges = true;
	}
	if (mouse_check_button_pressed(mb_right))
	{
		rightClick(objEditor.propertiesOf);
		objEditor.unsavedChanges = true;
	}
}
else
{
	hover = false;
}
