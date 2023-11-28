class_name TripleJump
extends Jump
## Third consecutively timed jump.


func _tell_switch():
	if actor.is_on_floor():
		return &"BackflipStyle"

	if Input.is_action_just_pressed("down"):
		return &"GroundPound"

	if movement.can_wallslide():
		return &"Wallslide"

	return &""
