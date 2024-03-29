class_name Twirl
extends PlayerState
## Spinning in the air after having airborne spinned once already.


## How much the twirl sends you upwards.
@export var spin_power: float = 6

## If the initial spin action has finished or not.
var finished_init: bool


func _on_enter(_handover):
	if movement.can_air_action():
		actor.vel.y = -spin_power

	movement.activate_freefall_timer()
	movement.consume_coyote_timer()


func _post_tick():
	movement.apply_gravity()


func _cycle_tick():
	movement.move_x("air", false)

	if not actor.doll.is_playing():
		finished_init = true


func _on_exit():
	finished_init = false


func _tell_switch():
	if actor.is_on_floor():
		return &"Idle"

	if finished_init and movement.can_air_action() and input.buffered_input(&"spin"):
		reset_state()

	if not movement.can_air_action() and input.buffered_input(&"spin"):
		return &"Spin"

	if movement.finished_freefall_timer():
		return &"Freefall"

	if Input.is_action_just_pressed(&"down") and movement.can_air_action():
		return &"GroundPound"

	if movement.can_wallslide():
		return &"Wallslide"

	return &""
