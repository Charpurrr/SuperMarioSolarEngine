class_name Idle
extends PlayerState
## Default grounded state when there is no input.


func _cycle_tick():
	actor.movement.decelerate("ground")


func _tell_switch():
	if Input.is_action_pressed("down"):
		return &"Crouch"

	if Input.is_action_just_pressed("jump"):
		return &"Jump"

	if InputManager.get_x() != 0:
		return &"Walk"

	return &""
