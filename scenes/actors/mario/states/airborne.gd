class_name Airborne
extends PlayerState
## A base state for all airborne states.


func _tell_switch():
	if actor.is_on_floor() and not actor.movement.active_buffer_jump():
		return &"Idle"

	if Input.is_action_just_pressed("jump") and actor.movement.active_coyote_time():
		return &"Jump"

	return &""
