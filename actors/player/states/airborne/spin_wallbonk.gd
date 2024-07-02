class_name SpinWallbonk
extends PlayerState
## Spin during a wallslide.

## Horizontal knockback from spinning against a wall.
@export var wall_kickback_power_x: float = 1.7
## Vertical knockback from spinning against a wall. (Only applied when airborne.)
@export var wall_kickback_power_y: float = 0.6

## Whether the initial spin action has finished or not.
var finished_init: bool


func _on_enter(_handover):
	movement.return_res_prog = movement.return_res
	movement.air_spun = true

	movement.activate_freefall_timer()
	movement.consume_coyote_timer()

	actor.vel.x = wall_kickback_power_x * -movement.facing_direction
	actor.vel.y = -wall_kickback_power_y


func _subsequent_ticks():
	movement.apply_gravity()


func _physics_tick():
	movement.move_x("air", false)

	if not actor.doll.is_playing():
		finished_init = true


func _on_exit():
	finished_init = false


func _trans_rules():
	if actor.is_on_floor():
		return &"Idle"

	if not movement.dived and movement.can_air_action() and input.buffered_input(&"dive"):
		if Input.is_action_pressed(&"down"):
			return [&"FaceplantDive", actor.vel.x]
		else:
			return [&"Dive", false]

	if finished_init and movement.can_air_action() and input.buffered_input(&"spin"):
		return &"Twirl"

	if movement.finished_freefall_timer():
		return &"Freefall"

	if Input.is_action_just_pressed(&"groundpound") and movement.can_air_action():
		return &"GroundPound"

	if finished_init and movement.can_init_wallslide():
		return &"Wallslide"

	return &""
