class_name SpinWallbonk
extends Spin
## Spun during a wallslide.


func _trans_rules():
	if actor.is_on_floor():
		return &"Idle"

	if finished_init and movement.can_air_action() and input.buffered_input(&"dive"):
		return [&"Dive", false]

	if movement.finished_freefall_timer():
		return &"Freefall"

	if Input.is_action_just_pressed(&"down") and movement.can_air_action():
		return [&"GroundPound", false]

	if finished_init and movement.can_wallslide():
		return &"Wallslide"

	return &""
