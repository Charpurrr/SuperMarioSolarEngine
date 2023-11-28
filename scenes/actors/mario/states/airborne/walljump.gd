class_name Walljump
extends PlayerState
## Jumping from a wallslide.


const PUSH_POWER: float = 3
const JUMP_POWER: float = 8.15


func _on_enter(_handover):
	movement.update_direction(-movement.facing_direction)

	actor.vel.y = -JUMP_POWER
	actor.vel.x = PUSH_POWER * movement.facing_direction

	movement.consec_jumps = 1


func _cycle_tick():
	if input_direction != movement.facing_direction:
		movement.move_x(0.13, false)
	elif input_direction != 0:
		movement.move_x("air", false)

	movement.apply_gravity(-actor.vel.y / JUMP_POWER)
	movement.decelerate(0.01)


func _tell_switch():
	if actor.vel.y > 0:
		return &"Fall"

	if Input.is_action_just_pressed("down"):
		return &"GroundPound"

	return &""
