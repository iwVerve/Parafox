function addToUndo(editor)
{
	ds_list_add(editor.undoStack, editor.level.serialize());
	if (ds_list_size(editor.undoStack) > global.undoStackSize)
	{
		ds_list_delete(editor.undoStack, 0);
	}
}

function undoAction(editor)
{
	var str = editor.level.serialize();
	if (str == editor.undoStack[| ds_list_size(editor.undoStack) - 1])
	{
		ds_list_delete(editor.undoStack, ds_list_size(editor.undoStack) - 1);
	}
	if (ds_list_size(editor.undoStack) > 0)
	{
		editor.parse(editor.undoStack[| ds_list_size(editor.undoStack) - 1]);
		ds_list_delete(editor.undoStack, ds_list_size(editor.undoStack) - 1);
		updateWallIndexes(editor.editing);
	}
}

function tryAndAddUndo(editor)
{
	var str = editor.level.serialize();
	if (str != editor.undoStack[| ds_list_size(editor.undoStack) - 1])
	{
		addToUndo(editor);
	}
}
