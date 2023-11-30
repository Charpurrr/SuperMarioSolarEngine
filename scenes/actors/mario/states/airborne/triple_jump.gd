class_name TripleJump
extends Jump
## Third consecutively timed jump.


func _tell_switch():
	if actor.is_on_floor():
		return &"BackflipStyle"

	if input.buffered_input(&"spin"):
		if movement.can_airspin():
			return &"AirborneSpin"
		else:
			return &"GroundedSpin"

	if Input.is_action_just_pressed(&"down") and movement.can_groundpound():
		return &"GroundPound"

	if movement.can_wallslide():
		return &"Wallslide"

	return &""
