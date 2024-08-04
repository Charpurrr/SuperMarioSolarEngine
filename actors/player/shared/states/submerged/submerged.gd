class_name Submerged
extends PlayerState
## A base state for being submerged in water.


func _on_enter(_handover):
	movement.activate_consec_timer()
	movement.consume_freefall_timer()
	movement.air_spun = false
	movement.dived = false


func _trans_rules():
	if not movement.is_submerged():
		return &"Dry"

	return &""


func _defer_rules():
	return &"SwimIdle"
