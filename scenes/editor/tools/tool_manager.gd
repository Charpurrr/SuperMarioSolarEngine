class_name ToolManager
extends StateManager


func _physics_tick():
	live_substate = target_actor.current_tool
