class_name FallState
extends State
# Falling state


@onready var idle_state : State = %Idle


func physics_tick(_delta):
	actor.vel.y += actor.movement.GRAVITY
	actor.vel.y = min(actor.vel.y, actor.movement.TERM_VEL)


func switch_check():
	if actor.is_on_floor():
		return idle_state
