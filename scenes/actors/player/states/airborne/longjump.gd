class_name Longjump
extends PlayerState
## Jumping forwards from a crouch.


@export var jump_power: float = 8.8
## How much the longjump sends you forwards.
@export var push_power: float = 1.2

## If the activate_freefall_timer() function should be called.
var start_freefall_timer: bool = false


func _on_enter(_handover):
	start_freefall_timer = false

	movement.update_direction(sign(movement.get_input_x()))
	movement.consec_jumps = 0

	actor.vel.y = -jump_power


func _post_tick():
	movement.apply_gravity(-actor.vel.y / jump_power, 1.2)


func _cycle_tick():
	movement.accelerate(0.2, InputManager.get_x_dir(), push_power)

	# NOTE TO SELF, check walljump for pushback

	if actor.vel.y > 0 and not start_freefall_timer:
		start_freefall_timer = true

		movement.activate_freefall_timer()


func _tell_switch():
	if movement.can_wallslide():
		return &"Wallslide"

	if input.buffered_input(&"dive"):
		return &"Dive"

	if movement.can_spin() and input.buffered_input(&"spin"):
		return &"Spin"

	if Input.is_action_just_pressed(&"down") and movement.can_air_action():
		return &"GroundPound"

	if actor.is_on_ceiling():
		return &"Fall"

	if movement.finished_freefall_timer():
		return &"Freefall"

	return &""
