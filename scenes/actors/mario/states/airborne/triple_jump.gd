class_name TripleJump
extends Jump
## Third consecutively timed jump.


## If the activate_freefall_timer() function should be called.
var start_freefall_timer: bool = false


func _on_enter(handover):
	super(handover)

	start_freefall_timer = false


func _cycle_tick():
	super()

	if actor.vel.y > 0 and not start_freefall_timer:
		start_freefall_timer = true

		movement.activate_freefall_timer()


func _tell_switch():
	if actor.is_on_floor():
		return &"TripleJumpStyle"

	if input.buffered_input(&"spin"):
		return &"Spin"

	if Input.is_action_just_pressed(&"down") and movement.can_groundpound():
		return &"GroundPound"

	if movement.can_wallslide():
		return &"Wallslide"

	if movement.finished_freefall_timer():
		return &"Freefall"

	return &""
