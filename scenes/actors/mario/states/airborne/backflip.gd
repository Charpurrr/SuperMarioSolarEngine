class_name Backflip
extends State
# Jumping while crouching


const PUSH_POWER : float = 1.4
const JUMP_POWER : float = 9.1


func on_enter():
	actor.animplay.play("backflip")

	actor.vel.y = -JUMP_POWER
	actor.vel.x = PUSH_POWER * -actor.movement.facing_direction


func on_exit():
	actor.animplay.stop()


func physics_tick(_delta):
	var input_direction : float = actor.movement.get_input_x()

	if input_direction != actor.movement.facing_direction:
		actor.movement.move_x(0.04, false)
	elif input_direction != 0:
		actor.movement.move_x(0.07, false)

	actor.movement.apply_gravity(-actor.vel.y / JUMP_POWER)


func switch_check():
	if actor.vel.y > 0:
		return get_states().fall

	if Input.is_action_just_pressed("down"):
		return get_states().groundpound
