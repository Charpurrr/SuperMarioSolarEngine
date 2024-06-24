class_name Grounded
extends PlayerState
## A base state for all grounded states.


func _on_enter(play_land_sfx):
	movement.activate_consec_timer()
	movement.consume_freefall_timer()
	movement.air_spun = false
	movement.dived = false

	actor.set_floor_snap_length(movement.snap_length)

	actor.vel.y = 0

	if play_land_sfx:
		for sfx_list in sfx_layers:
			sfx_list.play_sfx_at(self)


func _trans_rules():
	if not actor.is_on_floor():
		return &"Fall"

	if movement.is_steep_slope():
			return &"Slip"

	return &""


func _tell_defer():
	return &"Idle"
