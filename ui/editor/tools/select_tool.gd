class_name SelectTool
extends Tool
## Default all-purpose selection tool.


func _on_enter(_handover):
	pass


func _trans_rules():
	if actor.current_tool != self:
		return actor.current_tool.name

	return &""
