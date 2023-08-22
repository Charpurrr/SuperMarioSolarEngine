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
	if not actor.is_on_floor():
		return %Fall

	return null
