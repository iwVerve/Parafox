if !visible exit;

var str = name + " [" + string(value) + "]";

var m = global.buttonPadding;
var w = global.textScaleButton * string_width(str)
var h = global.textScaleButton * string_height(str);
if (inRange(mouse_x, x + m, x - m - w) && inRange(mouse_y, y - m, y + m + h))
{
	hover = true;
	if (!objEditor.frameDelay && mouse_check_button_pressed(mb_left))
	{
		click(objEditor.propertiesOf);
		objEditor.frameDelay = true;
		objEditor.unsavedChanges = true;
	}
	if (!objEditor.frameDelay && mouse_check_button_pressed(mb_right))
	{
		rightClick(objEditor.propertiesOf);
		objEditor.frameDelay = true;
		objEditor.unsavedChanges = true;
	}
}
else
{
	hover = false;
}
