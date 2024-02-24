class_name Spinjump
extends TripleJump
## Jumping during a grounded spin attack.


func _cycle_tick():
	movement.move_x(0.15, false)

	if movement.can_release_jump(applied_variation, min_jump_power):
		applied_variation = true
		actor.vel.y *= 0.5

	if actor.vel.y > 0 and not start_freefall_timer:
		start_freefall_timer = true

		movement.activate_freefall_timer()


func _tell_switch():
	if actor.is_on_floor():
		return &"Idle"

	if actor.vel.y > 0 and input.buffered_input(&"spin"):
		return &"Twirl"

	if movement.finished_freefall_timer():
		return &"Freefall"

	if Input.is_action_just_pressed(&"down") and movement.can_air_action():
		return &"GroundPound"

	if movement.can_wallslide():
		return &"Wallslide"

	return &""
