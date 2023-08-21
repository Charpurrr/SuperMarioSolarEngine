class_name WalkState
extends State
# Moving left and right on the ground


func physics_tick(_delta):
	actor.doll.speed_scale = actor.vel.x / actor.movement.MAX_SPEED_X * 2
	actor.movement.move_x("ground", true)


func on_exit():
	actor.doll.speed_scale = 1


func switch_check():
	var input_direction : float = actor.movement.get_input_x()

	if input_direction != actor.movement.facing_direction:
		if abs(actor.vel.x) >= actor.movement.MAX_SPEED_X:
			return get_states().skid
		else:
			return get_states().idle

	if input_direction != 0 and actor.is_on_wall():
		if actor.push_ray.is_colliding():
			return get_states().push
		else:
			return get_states().dry_push

	if Input.is_action_pressed("down"):
		return get_states().crouch

	return null
