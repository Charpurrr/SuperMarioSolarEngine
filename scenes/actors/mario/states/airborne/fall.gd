class_name Fall
extends PlayerState
## Falling state.


func _on_enter(_handover):
	movement.activate_freefall_timer()


func _cycle_tick():
	movement.move_x("air", false)


func _post_tick():
	movement.apply_gravity()


func _tell_switch():
	if input.buffered_input(&"spin"):
		if movement.can_airspin():
			return &"AirborneSpin"
		else:
			return &"GroundedSpin"

	if Input.is_action_just_pressed(&"down") and movement.can_groundpound():
		return &"GroundPound"

	if movement.can_wallslide():
		return &"Wallslide"

	if movement.finished_freefall_timer():
		return &"Freefall"

	return &""
