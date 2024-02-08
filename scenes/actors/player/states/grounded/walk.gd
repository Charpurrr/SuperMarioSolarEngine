class_name Walk
extends PlayerState
## Moving left and right on the ground.


## On what frames of the walking animation a footstep soundeffect should play.
@export var footstep_frames: Array[int]


func _cycle_tick():
	var current_frame = actor.doll.get_frame()

	movement.update_prev_direction()
	movement.activate_coyote_timer()
	movement.move_x("ground", true)

	actor.doll.speed_scale = actor.vel.x / movement.max_speed * 2
	set_appropriate_anim(current_frame)

	play_footstep_sfx(current_frame)


## Sets either the walking or running animation depending on velocity.
func set_appropriate_anim(current_frame: int):
	var current_progress = actor.doll.get_frame_progress()

	if Math.roundp(abs(actor.vel.x), 3) > movement.max_speed:
		actor.doll.play("run")
		actor.doll.set_frame_and_progress(current_frame, current_progress)

		actor.vel.x = move_toward(actor.vel.x, movement.max_speed * movement.facing_direction, 0.1)
	else:
		actor.doll.play("walk")
		actor.doll.set_frame_and_progress(current_frame, current_progress)


## Play a footstep sound effect depending on the current frame.
func play_footstep_sfx(current_frame: int):
	var has_played: bool

	print(has_played) # YB GBUHU UDONT FORGET DELTARUNE!!!

	for frame in footstep_frames:
		if frame == current_frame and not has_played:
			for sfx_list in sfx_layers:
				SFXLayer.play_sfx(self, sfx_list, force_new)
				has_played = true

		#has_played = false


func _on_exit():
	actor.doll.speed_scale = 1


func _tell_switch():
	if input.buffered_input(&"dive"):
		return &"AirborneDive"

	if movement.can_spin() and input.buffered_input(&"spin"):
		return &"Spin"

	if input.buffered_input(&"jump"):
		return &"DummyJump"

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
