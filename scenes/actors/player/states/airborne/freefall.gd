class_name Freefall
extends Fall
## Uninterupted falling at terminal velocity.


func _on_enter(_handover):
	movement.consume_freefall_timer()


func _trans_rules():
	if movement.can_spin() and input.buffered_input(&"spin"):
		return &"Spin"

	if not movement.dived and input.buffered_input(&"dive") and movement.can_air_action():
		if Input.is_action_pressed(&"down"):
			return [&"FaceplantDive", 0.0]
		else:
			return [&"Dive", false]

	if Input.is_action_just_pressed(&"down") and movement.can_air_action():
		return &"GroundPound"

	if movement.can_init_wallslide():
		return &"Wallslide"

	return &""
