class_name Walljump
extends PlayerState
## Jumping from a wallslide.


const PUSH_POWER: float = 3
const JUMP_POWER: float = 8.15


func _on_enter(_handover):
	actor.movement.update_direction(-actor.movement.facing_direction)

	actor.vel.y = -JUMP_POWER
	actor.vel.x = PUSH_POWER * actor.movement.facing_direction


func _cycle_tick():
	if input_direction != actor.movement.facing_direction:
		actor.movement.move_x(0.13, false)
	elif input_direction != 0:
		actor.movement.move_x("air", false)

	actor.movement.apply_gravity(-actor.vel.y / JUMP_POWER)
	actor.movement.decelerate(0.01)


func _tell_switch():
	if actor.vel.y > 0:
		return &"Fall"

	if Input.is_action_just_pressed("down"):
		return &"GroundPound"

	return &""
