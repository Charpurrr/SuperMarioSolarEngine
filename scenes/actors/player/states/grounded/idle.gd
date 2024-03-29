class_name Idle
extends PlayerState
## Default grounded state when there is no input.


func _cycle_tick():
	movement.update_prev_direction()
	movement.decelerate("ground")


func _tell_switch():
	if Input.is_action_pressed(&"down"):
		return [&"Crouch", [false, true]]

	if movement.can_spin() and input.buffered_input(&"spin"):
		return &"Spin"

	if input.buffered_input(&"jump"):
		return &"DummyJump"

	if InputManager.get_x_dir() == movement.prev_facing_direction:
		return &"Walk"
	elif InputManager.get_x_dir() == -movement.prev_facing_direction:
		# Tiny margin to avoid making the skidding animation change frame perfect.
		if abs(actor.vel.x) < 1:
			return [&"Skid", [2, 8]]
		else:
			return [&"Skid", [0, 16]]

	return &""
