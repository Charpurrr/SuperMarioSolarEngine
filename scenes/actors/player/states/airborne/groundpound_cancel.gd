class_name GroundPoundCancel
extends Fall
## Pressing up after a groundpound.


func _trans_rules():
	if movement.can_spin() and input.buffered_input(&"spin"):
		return &"Twirl"

	if movement.can_air_action() and input.buffered_input(&"dive"):
		return [&"Dive", false]

	if Input.is_action_just_pressed(&"down") and movement.can_air_action():
		return [&"GroundPound", false]

	if movement.can_init_wallslide():
		return &"Wallslide"

	if movement.finished_freefall_timer():
		return &"Freefall"

	return &""
