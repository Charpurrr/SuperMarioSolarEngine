class_name Idle
extends PlayerState
## Default grounded state when there is no input.


func _cycle_tick():
	movement.decelerate("ground")


func _tell_switch():
	if Input.is_action_pressed(&"down"):
		return &"Crouch"

	if input.buffered_input(&"jump"):
		return &"DummyJump"

	if InputManager.get_x() != 0:
		return &"Walk"

	return &""
