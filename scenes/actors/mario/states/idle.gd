class_name IdleState
extends State
# Default grounded state when there is no input


@onready var crouch_state : State = %Crouch
@onready var walk_state : State = %Walk


func physics_tick(_delta):
	actor.movement.decelerate("ground")


func switch_check():
	var input_direction : float = actor.movement.get_input_x()

	if input_direction != 0:
		return walk_state

	if Input.is_action_pressed("down"):
		return crouch_state

	return null
