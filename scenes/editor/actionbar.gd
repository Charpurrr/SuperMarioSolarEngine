class_name ActionBar
extends MenuBar
## The editor's action bar.


@export var editor: LevelEditor = owner

## The tool with an ID of 0.
@export var tool_0: Tool
## The tool with an ID of 1.
@export var tool_1: Tool


func _on_popup_menu_id_pressed(id):
	match id:
		0:
			editor.current_tool = tool_0
		1:
			editor.current_tool = tool_1
		_:
			pass
