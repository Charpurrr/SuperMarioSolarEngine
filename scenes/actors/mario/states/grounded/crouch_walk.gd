class_name CrouchWalk
extends PlayerState
## Walking whilst crouching on the floor.


var crouch_walk_speed: float = movement.MAX_SPEED_X / 2


func _on_enter(_handover):
#	movement.consume_coyote_timer()

	actor.hitbox.disabled = true
	actor.small_hitbox.disabled = false


func _cycle_tick():
#	movement.update_direction(input_direction)
	movement.activate_coyote_timer()
	movement.move_x(0.10, true, crouch_walk_speed)

	actor.doll.speed_scale = actor.vel.x / crouch_walk_speed


func _on_exit():
	actor.hitbox.disabled = false
	actor.small_hitbox.disabled = true

	actor.doll.speed_scale = 1


func _tell_switch():
	if (input_direction == 0 or is_zero_approx(actor.vel.x)):
		return &"Crouch"

	# FIGURE OUT HOW TO USE HANDOVER OR PROBE TO skip first frame

	if Input.is_action_just_pressed(&"jump"):
		return &"Backflip"

	if not Input.is_action_pressed(&"down"):
		return &"Idle"

	return &""
