class_name Spinjump
extends PlayerState
## Jumping during a grounded spin attack.


## How much the spin sends you upwards when airborne.
@export var spin_power: float = 6

## Horizontal knockback from spinning against a wall.
@export var wall_kickback_power_x: float = 1.2
## Vertical knockback from spinning against a wall (only applied when airborne.)
@export var wall_kickback_power_y: float = 1.2

## If the initial spin action has finished or not.
var finished_init: bool


func _on_enter(_handover):
	actor.vel.y = -spin_power

	movement.activate_freefall_timer()
	movement.consume_coyote_timer()
	movement.consec_jumps = 1


func _post_tick():
	movement.apply_gravity(-actor.vel.y / spin_power)


func _cycle_tick():
	movement.move_x("air", false)

	if not actor.doll.is_playing():
		finished_init = true


func _on_exit():
	finished_init = false


func _tell_switch():
	if actor.is_on_floor():
		return &"Idle"

	if finished_init and actor.vel.y > 0 and input.buffered_input(&"spin"):
		return &"Twirl"

	if movement.finished_freefall_timer():
		return &"Freefall"

	if Input.is_action_just_pressed(&"down") and movement.can_air_action():
		return &"GroundPound"

	if movement.can_wallslide() and finished_init:
		return &"Wallslide"

	return &""
