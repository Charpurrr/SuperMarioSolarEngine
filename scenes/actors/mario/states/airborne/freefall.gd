class_name Freefall
extends Fall
## Uninterupted falling at terminal velocity.


func _tell_switch():
	if Input.is_action_just_pressed(&"kick"):
		return &"JumpKick"

	if Input.is_action_just_pressed(&"down"):
		return &"GroundPound"

	if movement.can_wallslide():
		return &"Wallslide"

	return &""
