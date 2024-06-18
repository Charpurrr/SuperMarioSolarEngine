class_name Sideflip
extends PlayerState
## Jumping after turning.

@export var jump_power: float = 8.8
## How much the sideflip sends you forwards.
@export var push_power: float = 1.2

## If the activate_freefall_timer() function should be called.
var start_freefall_timer: bool = false


func _on_enter(_handover):
	start_freefall_timer = false

	movement.update_direction(sign(movement.get_input_x()))
	movement.consec_jumps = 1

	actor.vel.y = -jump_power
	actor.vel.x = push_power * InputManager.get_x_dir()


func _subsequent_ticks():
	movement.apply_gravity(-actor.vel.y / jump_power)


func _physics_tick():
	movement.move_x(0.1, false)

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

	if Input.is_action_just_pressed(&"down") and movement.can_air_action():
		return &"GroundPound"

	if actor.is_on_ceiling():
		return &"Fall"

	if movement.finished_freefall_timer():
		return &"Freefall"

	return &""
