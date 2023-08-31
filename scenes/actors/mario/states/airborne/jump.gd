class_name JumpState
extends State
# Jumping state


const JUMP_POWER : float = 6.8


func on_enter():
	actor.vel.y = -JUMP_POWER


func physics_tick(_delta):
	actor.movement.move_x("air", false)
	actor.movement.apply_gravity(-actor.vel.y / JUMP_POWER)

	if Input.is_action_just_released("jump"):
		actor.vel.y *= 0.5


func switch_check():
	if actor.vel.y > 0:
		return get_states().fall
