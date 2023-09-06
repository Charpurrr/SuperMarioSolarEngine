class_name GroundedState
extends State
# A base state for all grounded states


@onready var substates : Dictionary = {
	turn_skid = %TurnSkid,
	stop_skid = %StopSkid,
	slow_turn = %SlowTurn,
	dry_push = %DryPush,
	crouch = %Crouch,
	idle = %Idle,
	walk = %Walk,
	push = %Push,
}


func switch_check():
	var input_direction : float = actor.movement.get_input_x()

	if not actor.is_on_floor():
		return %Fall

	return null
