class_name GroundPoundFall
extends PlayerState
## Falling after performing a ground pound.


## How fast you ground pound.
const GP_FALL_VEL = 9


func _cycle_tick():
	movement.move_x(0.04, false)
	actor.vel.y = GP_FALL_VEL


func _tell_switch():
	if actor.is_on_floor():
		return &"Idle"

	if Input.is_action_just_pressed("up"):
		return &"Fall"

	return &""
