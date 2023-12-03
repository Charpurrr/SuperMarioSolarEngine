class_name Freefall
extends Fall
## Uninterupted falling at terminal velocity.


func _on_enter(_handover):
	movement.consume_freefall_timer()


func _tell_switch():
	if input.buffered_input(&"spin") and movement.can_spin():
		return &"Spin"

	if Input.is_action_just_pressed(&"down") and movement.can_groundpound():
		return &"GroundPound"

	if movement.can_wallslide():
		return &"Wallslide"

	return &""
