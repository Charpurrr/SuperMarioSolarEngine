class_name Crouch
extends PlayerState
## Holding down on the floor.


func _cycle_tick():
	var direction = sign(input_direction)

	movement.update_direction(direction)
	movement.decelerate("ground")


func _tell_switch():
	if not Input.is_action_pressed(&"down") and actor.vel.x == 0:
		return &"Idle"

	if Input.is_action_just_pressed(&"jump"):
		return &"Backflip"

	return &""
