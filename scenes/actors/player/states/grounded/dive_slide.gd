class_name DiveSlide
extends PlayerState
## Sliding on the ground after a dive.


func _physics_tick():
	actor.doll.rotation = lerp_angle(actor.doll.rotation, movement.body_rotation * movement.facing_direction, 0.5)
	movement.decelerate("ground")


func _on_exit():
	movement.body_rotation = 0
	actor.doll.rotation = 0


func _trans_rules():
	if not actor.crouchlock.enabled:
		if input.buffered_input(&"dive"):
			return [&"Dive", true]

		if input.buffered_input(&"jump") or Input.is_action_pressed(&"jump"):
			return &"Rollout"

	if Input.is_action_just_pressed(&"down"):
		return [&"Crouch", [true, false]]

	if is_zero_approx(actor.vel.x) or Input.is_action_just_pressed(&"left") or Input.is_action_just_pressed(&"right"):
		if actor.crouchlock.enabled:
			return [&"Crouch", [true, false]]

		return &"Idle"

	return &""
