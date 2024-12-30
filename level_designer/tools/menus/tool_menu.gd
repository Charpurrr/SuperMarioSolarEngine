extends PanelContainer
class_name ToolMenu
## Submenus intended for [Tool] options (selecting tool modes, shapes, functions, etc.)

## NOTE: ToolMenus should be instantiated on opening the editor, NOT when a specific tool is selected.

## A reference to the instantiated [Tool] that this menu configures.
@export var paired_tool: Tool

## Sets tool property values based on inputs from the ToolMenu
func set_tool_property(property_name : String, value):
	if paired_tool.get(property_name) != null and typeof(paired_tool.get(property_name)) == typeof(value):
		paired_tool.set(property_name, value)
