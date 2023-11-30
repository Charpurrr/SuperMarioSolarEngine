class_name Crouch
extends PlayerState
## Holding down on the floor.


## Skips the first frame of the crouching animation when true.
## Usually set by the predecessor state.
var skip_first_frame: bool = false


func _on_enter(_handover):
	actor.hitbox.disabled = true
	actor.small_hitbox.disabled = false


func _pre_tick():
	if skip_first_frame:
		actor.doll.set_frame(1)


func _cycle_tick():
	movement.update_direction(sign(input_direction))
	movement.decelerate(0.07)


func _on_exit():
	actor.hitbox.disabled = false
	actor.small_hitbox.disabled = true

	skip_first_frame = false


func _tell_switch():
	if not Input.is_action_pressed(&"down"):
		return &"Idle"

	if actor.vel.x == 0 and input_direction != 0:
		return &"CrouchWalk"

	if Input.is_action_just_pressed(&"jump"):
		return &"Backflip"


	return &""
