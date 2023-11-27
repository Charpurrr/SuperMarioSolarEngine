class_name Grounded
extends PlayerState
## A base state for all grounded states.


func _on_enter(_handover):
	print("entered grounded")
	movement.activate_consec_jump_timer()


func _tell_switch():
	if not actor.is_on_floor():
		return &"Fall"

	return &""


func _tell_defer():
	var leaf: State = manager.get_leaf()

	if leaf.name == &"Backflip":
		return &"BackflipStyle"

	return &"Idle"
