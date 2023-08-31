class_name SideflipState
extends State
# Jumping after turning


const PUSH_POWER : float = 1.2
const JUMP_POWER : float = 8


func on_enter():
	var input_direction : float = actor.movement.get_input_x()

	actor.vel.y = -JUMP_POWER
	actor.animplay.play("sideflip")
	actor.vel.x = PUSH_POWER * input_direction
	


func on_exit():
	actor.animplay.stop()


func physics_tick(delta):
	actor.movement.move_x(0.1, true)
	actor.movement.apply_gravity(-actor.vel.y / JUMP_POWER)


func switch_check():
	if actor.is_on_ceiling():
		return get_states().fall
