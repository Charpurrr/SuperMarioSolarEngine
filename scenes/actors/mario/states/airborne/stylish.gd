class_name Stylish
extends PlayerState
## Stylish cheer after a move.


func _cycle_tick():
	movement.decelerate("ground")


func _tell_switch():
	if not av.fallback_sprite.is_playing():
		return &"Idle"

	if input_direction != 0:
		return &"Walk"

	if Input.is_action_pressed(&"down"):
		return &"Crouch"

	if Input.is_action_just_pressed(&"jump"):
		return &"DummyJump"

	return &""
