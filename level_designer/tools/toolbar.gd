class_name Toolbar
extends PanelContainer
## Holds data for the currently active tool.

@export var editor: LevelEditor

@export_category(&"Local References")
@export var select: SelectTool
@export var pen: Tool
@export var erase: Tool
@export var eyedrop: Tool
@export var shape: Tool
@export var gravity: Tool

var active_tool: Tool


func _ready():
	update_active_tool(select)


func update_active_tool(new_tool: Tool):
	editor.level_preview.cancel_brush()
	if active_tool != null:
		active_tool.deactivate()
	new_tool.activate()

	active_tool = new_tool

	Input.set_custom_mouse_cursor(
		active_tool.default_mouse_icon, active_tool.mouse_shape, active_tool.hotspot
	)


func drop_tools():
	if active_tool == null:
		return
	active_tool.deactivate()
	active_tool = null
	Input.set_custom_mouse_cursor(null)
