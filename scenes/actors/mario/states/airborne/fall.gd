class_name Fall
extends PlayerState
## Falling state.

const FREEFALL_TIME: int = 70
var freefall_timer: int


func _on_enter(_handover):
	freefall_timer = FREEFALL_TIME


func _cycle_tick():
	freefall_timer = max(freefall_timer - 1, 0)

	movement.move_x("air", false)


func _post_tick():
	movement.apply_gravity()


func _tell_switch():
	if Input.is_action_just_pressed(&"kick"):
		return &"JumpKick"

	if Input.is_action_just_pressed(&"down"):
		return &"GroundPound"

	if movement.can_wallslide():
		return &"Wallslide"

	if is_equal_approx(actor.vel.y, movement.TERM_VEL) and freefall_timer == 0:
		return &"Freefall"

	return &""
