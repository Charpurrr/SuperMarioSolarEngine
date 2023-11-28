class_name Sideflip
extends PlayerState
## Jumping after turning.


const PUSH_POWER: float = 1.2
const JUMP_POWER: float = 8.8

## If the activate_freefall_timer() function should be called.
var start_freefall_timer: bool = false


func _on_enter(_handover):
	start_freefall_timer = false

	movement.update_direction(sign(movement.get_input_x()))
	actor.vel.y = -JUMP_POWER

	movement.consec_jumps = 1


func _post_tick():
	movement.apply_gravity(-actor.vel.y / JUMP_POWER)


func _cycle_tick():
	if actor.vel.y < -JUMP_POWER + 1:
		actor.vel.x = PUSH_POWER * input_direction

	movement.move_x(0.1, false)

	if actor.vel.y > 0 and not start_freefall_timer:
		start_freefall_timer = true

		movement.activate_freefall_timer()


func _tell_switch():
	if actor.is_on_ceiling():
		return &"Fall"

	if movement.can_wallslide():
		return &"Wallslide"

	if movement.finished_freefall_timer():
		return &"Freefall"

	if Input.is_action_just_pressed("down"):
		return &"GroundPound"

	return &""
