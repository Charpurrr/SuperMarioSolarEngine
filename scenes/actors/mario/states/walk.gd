class_name WalkState
extends State
# Moving left and right on the ground


@onready var dry_push_state : State = %DryPush
@onready var crouch_state : State = %Crouch
@onready var idle_state : State = %Idle
@onready var skid_state : State = %Skid
@onready var push_state : State = %Push


func physics_tick(_delta):
	actor.doll.speed_scale = actor.vel.x / actor.movement.MAX_SPEED_X * 2
	actor.movement.move_x("ground", true)


func on_exit():
	actor.doll.speed_scale = 1


func switch_check():
	var input_direction : float = actor.movement.get_input_x()

	if input_direction != actor.movement.facing_direction:
		if abs(actor.vel.x) >= actor.movement.MAX_SPEED_X:
			return skid_state
		else:
			return idle_state

	if input_direction != 0 and actor.is_on_wall():
		if actor.push_ray.is_colliding():
			return push_state
		else:
			return dry_push_state

	if Input.is_action_pressed("down"):
		return crouch_state

	return null
