class_name Longjump
extends PlayerState
## Jumping forwards from a crouch.

@export var jump_power: float = 8.8
## How much the longjump sends you forwards.
@export var push_power: float = 1.2

## If the activate_freefall_timer() function should be called.
var start_freefall_timer: bool = false


func _on_enter(_param):
	start_freefall_timer = false

	movement.update_direction(sign(movement.get_input_x()))
	movement.consec_jumps = 0

	actor.vel.y = -jump_power


func _subsequent_ticks():
	movement.apply_gravity(-actor.vel.y / jump_power, 1.2)


func _physics_tick():
	if InputManager.get_x_dir() == movement.facing_direction:
		movement.accelerate(0.4, movement.facing_direction, push_power)
	else:
		movement.accelerate(0.2, InputManager.get_x_dir(), push_power)

	if actor.vel.y > 0 and not start_freefall_timer:
		start_freefall_timer = true

		movement.activate_freefall_timer()


func _trans_rules():
	if actor.push_rays.is_colliding() and input.buffered_input(&"jump"):
		return [&"Walljump", -movement.facing_direction]

	if movement.can_init_wallslide():
		return &"Wallslide"

	if not movement.dived and movement.can_air_action() and input.buffered_input(&"dive"):
		if Input.is_action_pressed(&"down"):
			return [&"FaceplantDive", actor.vel.x]
		else:
			return [&"Dive", false]

	if movement.can_spin() and input.buffered_input(&"spin"):
		return &"Spin"

	if Input.is_action_just_pressed(&"groundpound") and movement.can_air_action():
		return &"GroundPound"

	if actor.is_on_ceiling():
		return &"Fall"

	if movement.finished_freefall_timer():
		return &"Freefall"

	return &""
