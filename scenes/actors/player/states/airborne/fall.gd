class_name Fall
extends PlayerState
## Falling.


func _on_enter(_handover):
	movement.activate_freefall_timer()


func _cycle_tick():
	movement.move_x("air", true)


func _post_tick():
	movement.apply_gravity()


func _tell_switch():
	if input.buffered_input(&"spin") and movement.can_spin():
		return &"Spin"

	if Input.is_action_just_pressed(&"down") and movement.can_groundpound():
		return &"GroundPound"

	if movement.can_wallslide():
		return &"Wallslide"

	if movement.finished_freefall_timer():
		return &"Freefall"

	return &""
