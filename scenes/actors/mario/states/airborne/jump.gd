class_name JumpState
extends State
# Jumping state


const JUMP_POWER : float = 3


func on_enter():
	actor.vel.y = -JUMP_POWER


func physics_tick(_delta):
	actor.movement.move_x("air", true)
	actor.movement.apply_gravity()


func switch_check():
	if actor.vel.y > 0:
		return get_states().fall
