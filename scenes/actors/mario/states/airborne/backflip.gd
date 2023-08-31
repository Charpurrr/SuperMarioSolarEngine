class_name BackflipState
extends State
# Jumping while crouching


const PUSH_POWER : float = 1.4
const JUMP_POWER : float = 8


func on_enter():
	actor.vel.y = -JUMP_POWER
	actor.vel.x = PUSH_POWER * -actor.movement.facing_direction
	actor.movement.apply_gravity(-actor.vel.y / JUMP_POWER)

	actor.animplay.play("backflip")


func on_exit():
	actor.animplay.stop()


func physics_tick(_delta):
	actor.movement.move_x(0.08, false)
	actor.movement.apply_gravity(-actor.vel.y / JUMP_POWER)


func switch_check():
	if actor.vel.y > 0:
		return get_states().fall
