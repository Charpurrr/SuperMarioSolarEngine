class_name Spinjump
extends TripleJump
## Jumping during a grounded spin attack.


### How much the spin sends you upwards.
#@export var jump_power: float = 6
#
#
#func _on_enter(_handover):
	#actor.vel.y = -jump_power
#
	#movement.activate_freefall_timer()
	#movement.consume_coyote_timer()
	#movement.consec_jumps = 1
#
#
#func _post_tick():
	#movement.apply_gravity(-actor.vel.y / jump_power)
#
#
#func _cycle_tick():
	#movement.move_x("air", false)
#
	#if not actor.doll.is_playing():
		#finished_init = true
#
#
#func _on_exit():
	#finished_init = false
#
#
func _tell_switch():
	if actor.is_on_floor():
		return &"Idle"

	if actor.vel.y > 0 and input.buffered_input(&"spin"):
		return &"Twirl"

	if movement.finished_freefall_timer():
		return &"Freefall"

	if Input.is_action_just_pressed(&"down") and movement.can_air_action():
		return &"GroundPound"

	if movement.can_wallslide():
		return &"Wallslide"

	return &""
