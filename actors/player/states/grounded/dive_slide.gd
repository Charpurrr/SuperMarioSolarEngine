class_name DiveSlide
extends PlayerState
## Sliding on the ground after a dive.


func _on_enter(_handover):
	actor.floor_stop_on_slope = false


func _physics_tick():
	actor.doll.rotation = lerp_angle(actor.doll.rotation, 
	actor.get_floor_angle() + (TAU / 4 * movement.facing_direction), 0.5)
	movement.decelerate("ground")


func _on_exit():
	movement.body_rotation = 0

	actor.floor_stop_on_slope = true
	actor.doll.rotation = 0

func _trans_rules():
	if not actor.crouchlock.enabled:
		if input.buffered_input(&"dive"):
			return [&"Dive", true]

		if ((InputManager.get_x_dir() == movement.facing_direction or InputManager.get_x_dir() == 0) 
		and (input.buffered_input(&"jump") or Input.is_action_pressed(&"jump"))):
			return &"Rollout"

	if Input.is_action_just_pressed(&"down"):
		return [&"Crouch", [true, false]]

	if is_zero_approx(actor.vel.x) or InputManager.get_x_dir() == -movement.facing_direction:
		if actor.crouchlock.enabled:
			return [&"Crouch", [true, false]]

		return &"Idle"

	return &""
