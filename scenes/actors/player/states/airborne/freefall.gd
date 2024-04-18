class_name Freefall
extends Fall
## Uninterupted falling at terminal velocity.


func _on_enter(_handover):
	movement.consume_freefall_timer()


func _trans_rules():
	if movement.can_spin() and input.buffered_input(&"spin"):
		return &"Spin"

	if movement.can_air_action() and input.buffered_input(&"dive"):
		return [&"Dive", false]

	if Input.is_action_just_pressed(&"down") and movement.can_air_action():
		return &"GroundPound"

	if movement.can_wallslide():
		return &"Wallslide"

	return &""
