class_name Grounded
extends PlayerState
## A base state for all grounded states.


func _on_enter(_handover):
	movement.activate_consec_timer()
	movement.consume_freefall_timer()

	movement.last_wall = 0

	actor.set_floor_snap_length(8.0)


func _tell_switch():
	if not actor.is_on_floor():
		return &"Fall"

	return &""


func _tell_defer():
	var leaf: State = manager.get_leaf()

	if leaf.name == &"Backflip":
		return &"BackflipStyle"

	return &"Idle"
