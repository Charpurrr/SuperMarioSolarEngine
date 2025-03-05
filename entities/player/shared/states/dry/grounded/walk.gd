class_name Walk
extends PlayerState
## Moving left and right on the ground.

## On what frames of the walking animation a footstep soundeffect should play.
@export var footstep_frames: Array[int]

@export_category(&"Animation (Unique to State)")
@export var animation_run: StringName
@export var anim_offset_r: Vector2

## Wether the footstep sound effect has played or not.
var sfx_has_played: bool = false

var current_frame: int
var last_frame: int


func _physics_tick():
	current_frame = actor.doll.get_frame()

	movement.update_prev_direction()
	movement.activate_coyote_timer()
	movement.move_x_analog(movement.ground_accel_step, true, movement.ground_decel_step)

	actor.doll.speed_scale = actor.vel.x / movement.max_speed * 2
	_set_appropriate_anim()

	if current_frame != last_frame:
		for frame in footstep_frames:
			if frame == current_frame:
				particles[0].emit_at(actor) # Emit the first particle (dust kick) every footstep.
				_play_footstep_sfx()

	last_frame = current_frame


## Sets either the walking or running animation depending on velocity.
func _set_appropriate_anim():
	var current_progress = actor.doll.get_frame_progress()

	if snappedf(abs(actor.vel.x), 3) > movement.max_speed:
		actor.doll.play(animation_run)
		actor.doll.set_frame_and_progress(current_frame, current_progress)

		actor.vel.x = move_toward(actor.vel.x, movement.max_speed * movement.facing_direction, 0.1)
	else:
		actor.doll.play(animation)
		actor.doll.set_frame_and_progress(current_frame, current_progress)


## Play the footstep sound effect.
func _play_footstep_sfx():
	for sfx_list in sfx_layers:
		sfx_list.play_sfx_at(self)


func _on_exit():
	actor.doll.speed_scale = 1


func _trans_rules():
	if input.buffered_input(&"dive"):
		return &"Dive"

	if movement.can_spin() and input.buffered_input(&"spin"):
		return &"Spin"

	if input.buffered_input(&"jump"):
		return &"DummyJump"

	if InputManager.get_x_dir() == -movement.prev_facing_direction and abs(actor.vel.x) > 1:
		movement.update_prev_direction()
		return [&"Skid", [0, 16]]

	if not InputManager.is_moving_x():
		return &"Idle"

	if Input.is_action_pressed(&"down"):
		if movement.is_slide_slope():
			return &"ButtSlide"

		return [&"Crouch", [false, true]]

	if InputManager.get_x_dir() != 0 and actor.is_on_wall():
		if actor.push_rays.is_colliding():
			return &"Push"

		return &"DryPush"

	return &""
