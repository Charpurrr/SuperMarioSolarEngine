class_name GroundedState
extends State
# A base state for all grounded states


@onready var substates : Dictionary = {
	slow_turn = %SlowTurn,
	dry_push = %DryPush,
	crouch = %Crouch,
	idle = %Idle,
	walk = %Walk,
	skid = %Skid,
	push = %Push,
}


func switch_check():
	var input_direction : float = actor.movement.get_input_x()

	if actor.crouch_lock.has_overlapping_bodies() and input_direction == 0:
		return %Crouch

	if not actor.is_on_floor():
		return %Fall

	return null
