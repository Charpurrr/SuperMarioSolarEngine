class_name Waddle
extends PlayerState
## Walking whilse crouching on the floor.


## On what frames of the walking animation a footstep soundeffect should play.
@export var footstep_frames: Array[int]

## Wether the footstep sound effect has played or not.
var sfx_has_played: bool = false

var current_frame: int
var last_frame: int


func _on_enter(_handover):
	actor.hitbox.disabled = true
	actor.small_hitbox.disabled = false
	actor.dive_hitbox.disabled = true


func _cycle_tick():
	var crouch_walk_speed: float = movement.max_speed / 2

	current_frame = actor.doll.get_frame()

	movement.activate_coyote_timer()
	movement.move_x(0.12, true, crouch_walk_speed)

	current_frame = actor.doll.get_frame()
	actor.doll.speed_scale = actor.vel.x / crouch_walk_speed

	if current_frame != last_frame:
		_play_footstep_sfx()

	last_frame = current_frame


## Play a footstep sound effect depending on the current frame.
func _play_footstep_sfx():
	for frame in footstep_frames:
		if frame == current_frame:
			for sfx_list in sfx_layers:
				SFXLayer.play_sfx(self, sfx_list, force_new)


func _on_exit():
	actor.hitbox.disabled = false
	actor.small_hitbox.disabled = true
	actor.dive_hitbox.disabled = true

	actor.doll.speed_scale = 1


func _tell_switch():
	if (not InputManager.is_moving_x() or actor.is_on_wall()):
		return [&"Crouch", [true, false]]

	if input.buffered_input(&"jump"):
		if InputManager.get_x_dir() == 0:
			return &"Backflip"
		else:
			return &"Longjump"

	if not Input.is_action_pressed(&"down") and not actor.crouchlock.enabled:
		return &"Idle"

	return &""
