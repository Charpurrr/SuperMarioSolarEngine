class_name Twirl
extends PlayerState
## Spinning in the air after having airborne spinned once already.


## How much the twirl sends you upwards.
@export var spin_power: float = 6

## Horizontal knockback from twirling against a wall.
@export var wall_kickback_power_x: float = 1.2
## Vertical knockback from twirling against a wall.
@export var wall_kickback_power_y: float = 1.2

## If the initial spin action has finished or not.
var finished_init: bool


func _on_enter(_handover):
	if movement.can_air_action():
		actor.vel.y = -spin_power

	movement.activate_freefall_timer()
	movement.consume_coyote_timer()


func _post_tick():
	movement.apply_gravity(-actor.vel.y / spin_power)


func _cycle_tick():
	movement.move_x("air", false)

	if not actor.doll.is_playing():
		finished_init = true

	# Twirling wall bonk.
	if actor.push_ray.is_colliding():
		movement.return_res_prog = movement.return_res

		actor.vel.x = wall_kickback_power_x * -movement.facing_direction
		actor.vel.y = wall_kickback_power_y * -movement.facing_direction


func _on_exit():
	finished_init = false


func _tell_switch():
	if not movement.can_air_action():
		return &"Spin"

	if actor.is_on_floor():
		return &"Idle"

	if input.buffered_input(&"spin") and finished_init:
		reset_state()

	if movement.finished_freefall_timer():
		return &"Freefall"

	if Input.is_action_just_pressed(&"down") and movement.can_air_action():
		return &"GroundPound"

	if movement.can_wallslide():
		return &"Wallslide"

	return &""
