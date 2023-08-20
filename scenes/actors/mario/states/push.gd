class_name PushState
extends State
# Walking against a solid body while the ray_shape is colliding


@onready var crouch_state : State = %Crouch
@onready var idle_state : State = %Idle
@onready var walk_state : State = %Walk
@onready var jump_state : State = %Jump


func switch_check():
	var input_direction : float = actor.movement.get_input_x()

	if input_direction == 0:
		return idle_state
	elif (input_direction == -actor.movement.facing_direction or actor.movement.check_space_ahead()):
		return walk_state

	if Input.is_action_just_pressed("jump"):
		return jump_state

	if Input.is_action_pressed("down"):
		return crouch_state

	return null
