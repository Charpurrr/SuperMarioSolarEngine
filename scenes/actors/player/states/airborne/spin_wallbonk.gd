class_name SpinWallbonk
extends Spin
## Spin during a wallslide.


func _trans_rules():
	if actor.is_on_floor():
		return &"Idle"

	if not movement.dived and finished_init and input.buffered_input(&"dive") and movement.can_air_action():
		if Input.is_action_pressed(&"down"):
			return [&"FaceplantDive", 0.0]
		else:
			return [&"Dive", false]

	if movement.finished_freefall_timer():
		return &"Freefall"

	if Input.is_action_just_pressed(&"down") and movement.can_air_action():
		return &"GroundPound"

	if finished_init and movement.can_init_wallslide():
		return &"Wallslide"

	return &""
