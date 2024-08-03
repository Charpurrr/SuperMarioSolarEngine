class_name Stylish
extends PlayerState
## Stylish cheer after a move.


func _physics_tick():
	movement.decelerate(movement.ground_decel_step)


func _trans_rules():
	if not actor.doll.is_playing():
		return &"Idle"

	if InputManager.is_moving_x():
		return &"Walk"

	if movement.can_spin() and input.buffered_input(&"spin"):
		return &"Spin"

	if Input.is_action_pressed(&"down"):
		return [&"Crouch", [false, true]]

	if input.buffered_input(&"jump"):
		return &"DummyJump"

	return &""
