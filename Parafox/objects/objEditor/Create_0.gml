level = instance_create_layer(0, 0, "Level", objLevel);
level.parse(fileToString("startup.txt"));

tool = TOOL.SELECT;
editing = level.block;
propertiesOf = noone;
selected = noone;
selectedTimer = 0;
doubleclickTimer = 0;
frameDelay = false;

dragging = false;
dragX = 0;
dragY = 0;

clipboard = noone;
editing.createProperties();

unsavedChanges = false;
filePath = "";

createButtons();

step = function()
{	
	if (window_get_width() != room_width || window_get_height() != room_height)
	{
		room_width = window_get_width();
		room_height = window_get_height();
		surface_resize(application_surface, room_width, room_height);
	}
	
	var w = 0.45 * min(room_width, room_height);
	var xx = room_width/2;
	var yy = room_height/2;
	var x1 = xx - w;
	var y1 = yy + w;
	var x2 = xx + w;
	var y2 = yy - w;
	
	resolveTool(tool, x1, y1, x2, y2);
	
	arrangeProperties();
	
	window_set_caption("Parafox" + ((unsavedChanges) ? "*" : ""));
	
	selectedTimer++;
	doubleclickTimer--;
	
	frameDelay = false;
}

draw = function()
{
	var w = 0.45 * min(room_width, room_height);
	var xx = room_width/2;
	var yy = room_height/2;
	editing.draw(xx-w, yy-w, xx+w, yy+w, 0);
	
	drawGUI();
}

drawGUI = function()
{
	draw_set_font(fntTool);
	draw_set_halign(fa_left);
	draw_set_valign(fa_bottom);
	draw_set_color(c_white);
	draw_text(8, room_height - 8, getToolText(tool));
	
	draw_set_halign(fa_right);
	var shownTooltip = "";
	with(objProperty)
	{
		if (hover)
		{
			shownTooltip = tooltip;
		}
	}
	with(objButton)
	{
		if (hover)
		{
			shownTooltip = tooltip;
		}
	}
	draw_text(room_width - 8, room_height - 8, shownTooltip);
}
