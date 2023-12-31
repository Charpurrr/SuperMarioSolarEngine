class_name ToolManager
extends StateManager


func _cycle_tick():
	live_substate = target_actor.current_tool
