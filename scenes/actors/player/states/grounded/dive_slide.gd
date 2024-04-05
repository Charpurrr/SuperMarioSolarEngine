class_name DiveSlide
extends PlayerState
## Sliding on the ground after an airborne dive.


func _physics_tick():
	actor.doll.rotation = lerp_angle(actor.doll.rotation, movement.body_rotation * movement.facing_direction, 0.5)
	movement.decelerate("ground")


func _on_exit():
	movement.body_rotation = 0
	actor.doll.rotation = 0

	actor.hitbox.disabled = false
	actor.small_hitbox.disabled = true
	actor.dive_hitbox.disabled = true


func _trans_rules():
	if Input.is_action_just_pressed(&"down"):
		return [&"Crouch", [true, false]]

	if is_zero_approx(actor.vel.x) or InputManager.is_moving_x():
		if actor.crouchlock.enabled:
			return [&"Crouch", [true, false]]

		return &"Idle"

	return &""
