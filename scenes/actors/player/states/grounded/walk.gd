class_name Walk
extends PlayerState
## Moving left and right on the ground.


## On what frames of the walking animation a footstep soundeffect should play.
@export var footstep_frames: Array[int]

## Wether the footstep sound effect has played or not.
var sfx_has_played: bool = false

var current_frame: int
var last_frame: int


func _physics_tick():
	current_frame = actor.doll.get_frame()

	movement.update_prev_direction()
	movement.activate_coyote_timer()
	movement.move_x("ground", true)

	actor.doll.speed_scale = actor.vel.x / movement.max_speed * 2
	_set_appropriate_anim()

	if current_frame != last_frame:
		_play_footstep_sfx()

	last_frame = current_frame


## Sets either the walking or running animation depending on velocity.
func _set_appropriate_anim():
	var current_progress = actor.doll.get_frame_progress()

	if Math.roundp(abs(actor.vel.x), 3) > movement.max_speed:
		actor.doll.play("run")
		actor.doll.set_frame_and_progress(current_frame, current_progress)

		actor.vel.x = move_toward(actor.vel.x, movement.max_speed * movement.facing_direction, 0.1)
	else:
		actor.doll.play("walk")
		actor.doll.set_frame_and_progress(current_frame, current_progress)


## Play a footstep sound effect depending on the current frame.
func _play_footstep_sfx():
	for frame in footstep_frames:
		if frame == current_frame:
			for sfx_list in sfx_layers:
				SFXLayer.play_sfx(self, sfx_list, force_new)


func _on_exit():
	actor.doll.speed_scale = 1


func _trans_rules():
	if input.buffered_input(&"dive"):
		return [&"Dive", false]

	if movement.can_spin() and input.buffered_input(&"spin"):
		return &"Spin"

	if input.buffered_input(&"jump"):
		return &"DummyJump"

	if InputManager.get_x_dir() == -movement.prev_facing_direction:
		movement.update_prev_direction()
		return [&"Skid", [0, 16]]

	if !InputManager.is_moving_x():
		return &"Idle"

	if Input.is_action_pressed(&"down"):
		if movement.is_slide_slope():
			return &"ButtSlide"
		else: 
			return [&"Crouch", [false, true]]

	if InputManager.get_x() != 0 and actor.is_on_wall():
		if actor.push_rays.check_push():
			return &"Push"
		else:
			return &"DryPush"

	return &""
