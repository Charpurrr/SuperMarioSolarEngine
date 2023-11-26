class_name Backflip
extends PlayerState
## Jumping while crouching.


const PUSH_POWER: float = 1.4
const JUMP_POWER: float = 9.1


func _on_enter(_handover):
	actor.animplay.play("backflip")

	actor.vel.y = -JUMP_POWER
	actor.vel.x = PUSH_POWER * -actor.movement.facing_direction


func _on_exit():
	actor.animplay.stop()


func _cycle_tick():
	if input_direction != actor.movement.facing_direction:
		actor.movement.move_x(0.04, false)
	elif input_direction != 0:
		actor.movement.move_x(0.07, false)


func _post_tick():
	actor.movement.apply_gravity(-actor.vel.y / JUMP_POWER)


func _tell_switch():
	if actor.vel.y > 0:
		return &"Fall"

	if Input.is_action_just_pressed("down"):
		return &"GroundPound"

	return &""
