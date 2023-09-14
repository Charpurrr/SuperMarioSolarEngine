class_name GroundPoundFall
extends State
# Falling after performing a ground pound


const GP_FALL_VEL = 9 # How fast you ground pound


func physics_tick(_delta):
	actor.movement.move_x(0.04, false)
	actor.vel.y = GP_FALL_VEL


func switch_check():
	if actor.is_on_floor():
		return %Idle

	if Input.is_action_just_pressed("up"):
		return %Fall
