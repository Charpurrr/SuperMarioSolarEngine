class_name Stylish
extends PlayerState
## Stylish cheer after a move.


func _cycle_tick():
	movement.decelerate("ground")


func _tell_switch():
	if not actor.doll.is_playing():
		return &"Idle"

	if InputManager.is_moving_x():
		return &"Walk"

	if movement.can_spin() and input.buffered_input(&"spin"):
		return &"Spin"

	if input.buffered_input(&"jump"):
		return &"DummyJump"

	if Input.is_action_pressed(&"down"):
		return &"Crouch"

	return &""
