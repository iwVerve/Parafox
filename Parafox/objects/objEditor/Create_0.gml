level = instance_create_layer(0, 0, "Level", objLevel);
level.parse(fileToString("startup.txt"));

view = EDITORVIEW.EDIT;

tool = TOOL.SELECT;
editing = level.block;
propertiesOf = noone;
selected = noone;
selectedTimer = 0;
doubleclickTimer = 0;
frameDelay = false;

paintBrushColor = COLOR.A;

dragging = false;
dragX = 0;
dragY = 0;

clipboard = noone;
editing.createProperties();

unsavedChanges = false;
filePath = "";

gameStart = function()
{
	draw_set_font(fntDefault);
	createButtons();
	arrangeUIInstances();
}

step = function()
{	
	if ((window_get_width() > 0 && window_get_height() > 0) && (window_get_width() != room_width || window_get_height() != room_height))
	{
		room_width = window_get_width();
		room_height = window_get_height();
		surface_resize(application_surface, room_width, room_height);
	}
	
	switch(view)
	{
		case EDITORVIEW.EDIT:
			var w = 0.45 * min(room_width, room_height);
			var xx = room_width/2;
			var yy = room_height/2;
			var rect = new Rect(xx - w, yy + w, xx + w, yy - w);
	
			if (editing.flipH)
			{
				var temp = rect.x1;
				rect.x1 = rect.x2;
				rect.x2 = temp;
			}
	
			resolveTool(tool, rect);
			break;
		case EDITORVIEW.GRID:
			gridViewStep();
			break;
	}
	
	arrangeUIInstances();
	
	window_set_caption("Parafox" + ((unsavedChanges) ? "*" : ""));
	
	selectedTimer++;
	doubleclickTimer--;
	
	frameDelay = false;
}

draw = function()
{
	switch(view)
	{
		case EDITORVIEW.EDIT:
			var w = 0.45 * min(room_width, room_height);
			var xx = room_width/2;
			var yy = room_height/2
			var rect = new Rect(xx - w, yy - w, xx + w, yy + w);
	
			editing.draw(rect.clone(), 0);
			break;
		case EDITORVIEW.GRID:
			gridViewDraw();
			break;
	}
	
	drawGUI();
}

drawGUI = function()
{
	draw_set_halign(fa_left);
	draw_set_valign(fa_bottom);
	draw_set_color(c_white);
	draw_text_transformed(8, room_height - 8, getToolText(tool), global.textScaleTooltip, global.textScaleTooltip, 0);
	
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
	draw_text_transformed(room_width - 8, room_height - 8, shownTooltip, global.textScaleTooltip, global.textScaleTooltip, 0);
}
