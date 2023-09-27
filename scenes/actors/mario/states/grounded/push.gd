class_name Push
extends State
# Walking against a solid body while the ray_shape is colliding


func switch_check():
	var input_direction : float = actor.movement.get_input_x()

	if input_direction == 0:
		return get_states().idle
	elif (input_direction == -actor.movement.facing_direction or actor.movement.check_space_ahead()):
		return get_states().walk

	if Input.is_action_pressed("down"):
		return get_states().crouch

	if Input.is_action_just_pressed("jump"):
		return %Jump

	return null
