class_name GroundPoundCancel
extends Fall
## Pressing up after a groundpound.


func _tell_switch():
	if movement.can_spin() and input.buffered_input(&"spin"):
		if not movement.air_spun:
			return &"Spin"
		else:
			return &"Twirl"

	if Input.is_action_just_pressed(&"dive") and movement.can_air_action():
		return &"AirborneDive"

	if Input.is_action_just_pressed(&"down") and movement.can_air_action():
		return &"GroundPound"

	if movement.can_wallslide():
		return &"Wallslide"

	if movement.finished_freefall_timer():
		return &"Freefall"

	return &""
