class_name GroundedState
extends State
# A base state for all grounded states


@onready var substates : Dictionary = {
	crouch_walk = %CrouchWalk,
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

	if actor.crouch_lock.has_overlapping_bodies():
		if input_direction == 0:
			return %Crouch
		else:
			return %CrouchWalk

	if not actor.is_on_floor():
		return %Fall

	return null
