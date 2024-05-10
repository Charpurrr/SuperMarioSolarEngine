class_name Idle
extends PlayerState
## Default grounded state when there is no input.


func _physics_tick():
	movement.update_prev_direction()
	movement.decelerate("ground")


func _trans_rules():
	if actor.vel.x != 0 and input.buffered_input(&"dive"):
		return [&"Dive", false]

	if Input.is_action_pressed(&"down"):
		return [&"Crouch", [false, true]]

	if movement.can_spin() and input.buffered_input(&"spin"):
		return &"Spin"

	if InputManager.get_x_dir() == movement.prev_facing_direction:
		return &"Walk"
	elif InputManager.get_x_dir() == -movement.prev_facing_direction:
		# Tiny margin to avoid making the skidding animation change frame perfect.
		if abs(actor.vel.x) < 1:
			return [&"Skid", [2, 8]]
		else:
			return [&"Skid", [0, 16]]

	if input.buffered_input(&"jump"):
		return &"DummyJump"

	return &""
