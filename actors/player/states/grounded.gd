class_name Grounded
extends PlayerState
## A base state for all grounded states.


func _on_enter(play_land_sfx):
	movement.activate_consec_timer()
	movement.consume_freefall_timer()
	movement.air_spun = false
	movement.dived = false

	actor.set_floor_snap_length(8.0)

	if play_land_sfx:
		for sfx_list in sfx_layers:
				SFXLayer.play_sfx(self, sfx_list, force_new)


func _trans_rules():
	if not actor.is_on_floor():
		return &"Fall"

	return &""


func _tell_defer():
	return &"Idle"
