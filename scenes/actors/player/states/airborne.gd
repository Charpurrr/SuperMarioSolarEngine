class_name Airborne
extends PlayerState
## A base state for all airborne states.


func _cycle_tick():
	actor.set_floor_snap_length(0.0)


func _tell_switch():
	if actor.is_on_floor():
		return &"Grounded"

	if input.buffered_input(&"jump") and movement.active_coyote_time():
		return &"Jump"

	return &""
