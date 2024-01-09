class_name Walk
extends PlayerState
## Moving left and right on the ground.


func _cycle_tick():
	var current_frame = actor.doll.get_frame()
	var current_progress = actor.doll.get_frame_progress()

	movement.update_prev_direction()
	movement.activate_coyote_timer()
	movement.move_x("ground", true)

	# Switch between the running and walking animation depending on your velocity.
	if Math.roundp(abs(actor.vel.x), 3) > movement.max_speed:
		actor.doll.play("run")
		actor.doll.set_frame_and_progress(current_frame, current_progress)

		actor.vel.x = move_toward(actor.vel.x, movement.max_speed * movement.facing_direction, 0.1)
	else:
		actor.doll.play("walk")
		actor.doll.set_frame_and_progress(current_frame, current_progress)

	actor.doll.speed_scale = actor.vel.x / movement.max_speed * 2


func _on_exit():
	actor.doll.speed_scale = 1


func _tell_switch():
	if movement.can_spin() and input.buffered_input(&"spin"):
		return &"Spin"

	if input.buffered_input(&"jump"):
		return &"DummyJump"

	if Input.is_action_just_pressed(&"dive"):
		return &"AirborneDive"

	if InputManager.get_x_dir() == -movement.prev_facing_direction:
		movement.update_prev_direction()
		return [&"TurnSkid", [0, 16]]

	if !InputManager.is_moving_x():
		return &"Idle"

	if Input.is_action_pressed(&"down"):
		if movement.is_slide_slope():
			return &"ButtSlide"
		else: 
			return &"Crouch"

	if InputManager.get_x() != 0 and actor.is_on_wall():
		if actor.push_rays.check_push():
			return &"Push"
		else:
			return &"DryPush"

	return &""
