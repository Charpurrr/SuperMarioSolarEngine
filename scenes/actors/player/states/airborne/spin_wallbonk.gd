class_name SpinWallbonk
extends Spin
## Spun during a wallslide.


func _tell_switch():
	if actor.is_on_floor():
		return &"Idle"

	if finished_init and movement.can_air_action() and input.buffered_input(&"dive"):
		return &"Dive"

	if movement.finished_freefall_timer():
		return &"Freefall"

	if Input.is_action_just_pressed(&"down") and movement.can_air_action():
		return &"GroundPound"

	if finished_init and movement.can_wallslide():
		return &"Wallslide"

	return &""
