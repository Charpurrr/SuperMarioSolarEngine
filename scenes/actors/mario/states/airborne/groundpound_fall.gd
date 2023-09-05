class_name GroundPoundFall
extends State
# Falling after performing a ground pound


@onready var idle_state : State = %Idle

const GP_FALL_VEL = 9 # How fast you ground pound


func physics_tick(_delta):
	actor.movement.move_x(0.04, false)
	actor.vel.y = GP_FALL_VEL


func switch_check():
	if actor.is_on_floor():
		return idle_state
