class_name Crouch
extends PlayerState
## Holding down on the floor.


# The first entry in the array is wether the first frame 
# of the crouch animation should be skipped or not,
# the second entry is wether the crouch sound effect should be played or not.
func _on_enter(array):
	actor.hitbox.disabled = true
	actor.small_hitbox.disabled = false
	actor.dive_hitbox.disabled = true

	if array[0] == true:
		actor.doll.set_frame(1)

	if array[1] == true:
		for sfx_list in sfx_layers:
				SFXLayer.play_sfx(self, sfx_list, force_new)


func _physics_tick():
	movement.update_direction(InputManager.get_x_dir())
	movement.decelerate(0.07)


func _on_exit():
	actor.hitbox.disabled = false
	actor.small_hitbox.disabled = true
	actor.dive_hitbox.disabled = true


## Return whether or not you can crouchwalk.
func _can_crouchwalk() -> bool:
	return (actor.vel.x == 0 and InputManager.is_moving_x()
	and not actor.test_move(actor.transform, Vector2(0.1 * movement.facing_direction, 0)))


func _trans_rules():
	if movement.is_slide_slope():
		return &"ButtSlide"

	if _can_crouchwalk():
		return &"Waddle"

	if input.buffered_input(&"jump") and not actor.crouchlock.enabled:
		if InputManager.get_x_dir() == 0:
			return &"Backflip"
		else:
			return &"Longjump"

	if not Input.is_action_pressed(&"down") and not actor.crouchlock.enabled:
		return &"Idle"


	return &""
