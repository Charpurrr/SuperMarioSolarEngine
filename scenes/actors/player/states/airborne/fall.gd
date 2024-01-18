class_name Fall
extends PlayerState
## Falling.


func _on_enter(_handover):
	movement.activate_freefall_timer()


func _post_tick():
	movement.apply_gravity()


func _cycle_tick():
	movement.move_x("air", true)


func _tell_switch():
	if movement.can_spin() and input.buffered_input(&"spin"):
		return &"Spin"

	if movement.can_air_action() and input.buffered_input(&"dive"):
		return &"AirborneDive"

	if Input.is_action_just_pressed(&"down") and movement.can_air_action():
		return &"GroundPound"

	if movement.can_wallslide():
		return &"Wallslide"

	if movement.finished_freefall_timer():
		return &"Freefall"

	return &""
