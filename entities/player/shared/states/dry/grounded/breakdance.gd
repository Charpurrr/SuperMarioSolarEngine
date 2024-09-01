class_name Breakdance
extends Spin
## You already know. (Spinning while crouched.)


func _trans_rules():
	if not actor.doll.is_playing():
		return [&"Crouch", [true, false]]

	if movement.is_slide_slope():
		return &"ButtSlide"

	if not actor.crouchlock.enabled and input.buffered_input(&"jump"):
		if actor.vel.x == 0:
			return &"Backflip"

		return &"Longjump"

	return &""
