class_name IdleState
extends State
# Default grounded state when there is no input


func physics_tick(_delta):
	actor.movement.decelerate("ground")


func switch_check():
	var input_direction : float = actor.movement.get_input_x()

	if input_direction != 0:
		return get_states().walk

	if Input.is_action_pressed("down"):
		return get_states().crouch

	return null
