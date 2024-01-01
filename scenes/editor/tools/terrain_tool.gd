class_name TerrainTool
extends Tool
## Drawing and creating terrain.


func _on_enter(_handover):
	pass


func _tell_switch():
	if actor.current_tool != self:
		return actor.current_tool.name

	return &""
