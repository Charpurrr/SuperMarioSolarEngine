class_name Grounded
extends PlayerState
## A base state for all grounded states.


func _tell_switch():
	if not actor.is_on_floor():
		return &"Fall"

	return &""
