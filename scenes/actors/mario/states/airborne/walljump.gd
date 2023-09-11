class_name WalljumpState
extends State
# Jumping from a wallslide


const PUSH_POWER : float = 1.4
const JUMP_POWER : float = 9.5


func on_enter():
	actor.movement.update_direction(-actor.movement.facing_direction)
	actor.movement.apply_gravity(-actor.vel.y / JUMP_POWER)

	actor.vel.y = -JUMP_POWER
	actor.vel.x = PUSH_POWER * -actor.movement.facing_direction


func physics_tick(_delta):
	print(actor.vel.y)
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
