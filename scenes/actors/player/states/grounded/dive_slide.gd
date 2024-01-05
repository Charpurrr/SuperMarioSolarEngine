class_name DiveSlide
extends PlayerState
## Sliding on the ground after an airborne dive.


func _cycle_tick():
	actor.doll.rotation = lerp_angle(actor.doll.rotation, movement.body_rotation * movement.facing_direction, 0.5)
	movement.decelerate("ground")


func _on_exit():
	movement.body_rotation = 0
	actor.doll.rotation = 0

	actor.hitbox.disabled = false
	actor.small_hitbox.disabled = true
	actor.dive_hitbox.disabled = true


func _tell_switch():
	if is_zero_approx(actor.vel.x) or InputManager.is_moving_x():
		return &"Idle"

	return &""
