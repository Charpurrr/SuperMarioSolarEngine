class_name Idle
extends PlayerState
## Default grounded state when there is no input.


func _cycle_tick():
	movement.update_prev_direction()
	movement.decelerate("ground")


func _tell_switch():
	if Input.is_action_pressed(&"down"):
		return &"Crouch"

	if movement.can_spin() and input.buffered_input(&"spin"):
		return &"Spin"

	if input.buffered_input(&"jump"):
		return &"DummyJump"

	if input_direction == movement.prev_facing_direction:
		print(input_direction, "walk")
		return &"Walk"
	elif input_direction == -movement.prev_facing_direction:
		return &"TurnSkid"

	return &""
