class_name CrouchWalk
extends PlayerState
## Walking whilst crouching on the floor.


func _on_enter(_handover):
	actor.hitbox.disabled = true
	actor.small_hitbox.disabled = false
	actor.dive_hitbox.disabled = true


func _cycle_tick():
	var crouch_walk_speed: float = movement.max_speed / 2

	movement.activate_coyote_timer()
	movement.move_x(0.12, true, crouch_walk_speed)

	actor.doll.speed_scale = actor.vel.x / crouch_walk_speed


func _on_exit():
	actor.hitbox.disabled = false
	actor.small_hitbox.disabled = true
	actor.dive_hitbox.disabled = true

	actor.doll.speed_scale = 1


func _tell_switch():
	if (input_direction == 0 or actor.is_on_wall()):
		return [&"Crouch", true]

	if input.buffered_input(&"jump"):
		return &"Backflip"

	if not Input.is_action_pressed(&"down"):
		return &"Idle"

	return &""
