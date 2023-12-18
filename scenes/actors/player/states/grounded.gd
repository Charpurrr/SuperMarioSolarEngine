class_name Grounded
extends PlayerState
## A base state for all grounded states.


func _on_enter(_handover):
	movement.activate_consec_timer()
	movement.consume_freefall_timer()


func _cycle_tick():
	actor.set_floor_snap_length(100.0)
	actor.movement.body_rotation = actor.get_floor_angle() * actor.movement.facing_direction
	actor.doll.rotation = actor.movement.body_rotation


func _tell_switch():
	if not actor.is_on_floor():
		return &"Fall"

	return &""


func _tell_defer():
	var leaf: State = manager.get_leaf()

	if leaf.name == &"Backflip":
		return &"BackflipStyle"

	return &"Idle"
