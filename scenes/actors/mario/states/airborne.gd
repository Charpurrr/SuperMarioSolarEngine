class_name Airborne
extends PlayerState
## A base state for all airborne states.


func _tell_switch():
	if actor.is_on_floor():
		return &"Grounded"

	if Input.is_action_just_pressed(&"jump") and movement.active_coyote_time():
		return &"Jump"

	return &""
