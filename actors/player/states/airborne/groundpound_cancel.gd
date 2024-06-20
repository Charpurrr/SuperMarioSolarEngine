class_name GroundPoundCancel
extends Fall
## Pressing up after a groundpound.


func _physics_tick():
	var should_flip: bool

	should_flip = actor.position.y > movement.walljump_start_y + movement.walljump_turn_threshold

	movement.move_x("air", should_flip)


func _trans_rules():
	if movement.can_spin() and input.buffered_input(&"spin"):
		return &"Twirl"

	if not movement.dived and movement.can_air_action() and input.buffered_input(&"dive"):
		if Input.is_action_pressed(&"down"):
			return [&"FaceplantDive", actor.vel.x]
		else:
			return [&"Dive", false]

	if Input.is_action_just_pressed(&"down") and movement.can_air_action():
		return &"GroundPound"

	if actor.push_rays.is_colliding() and input.buffered_input(&"jump"):
		return [&"Walljump", -movement.facing_direction]

	if movement.can_init_wallslide():
		return &"Wallslide"

	if movement.finished_freefall_timer():
		return &"Freefall"

	return &""
