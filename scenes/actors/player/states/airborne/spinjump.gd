class_name Spinjump
extends Jump
## Jumping during a grounded spin attack.


func _cycle_tick():
	movement.move_x(0.15, false)


func _post_tick():
	if actor.vel.y < 0:
		movement.apply_gravity(-actor.vel.y / jump_power)
	if actor.vel.y > 0:
		movement.apply_gravity(1, 2)


func _tell_switch():
	if actor.is_on_floor():
		return &"Idle"

	if actor.is_on_ceiling():
		return &"Fall"

	if actor.vel.y > 0 and input.buffered_input(&"spin"):
		return &"Twirl"

	if movement.finished_freefall_timer():
		return &"Freefall"

	if Input.is_action_just_pressed(&"down") and movement.can_air_action():
		return &"GroundPound"

	if movement.can_wallslide():
		return &"Wallslide"

	return &""
