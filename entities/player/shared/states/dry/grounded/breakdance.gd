class_name CrouchSpin
extends Spin
## I think the class name is self-explanatory.


func _trans_rules():
	if not actor.doll.is_playing():
		return [&"Crouch", [true, false]]

	if movement.is_slide_slope():
		return &"ButtSlide"

	if not actor.auto_crouch_check.enabled and input.buffered_input(&"jump"):
		if actor.vel.x == 0:
			return &"Backflip"

		return &"Longjump"

	return &""
