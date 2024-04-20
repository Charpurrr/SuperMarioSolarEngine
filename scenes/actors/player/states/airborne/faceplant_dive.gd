class_name FaceplantDive
extends Dive
## Diving while holding down in the air.


func _on_enter(_handover):
	movement.consume_coyote_timer()
	movement.consec_jumps = 0

	actor.vel.y = y_power

	if movement.facing_direction != sign(actor.vel.x):
		actor.vel.x = 0

	if is_equal_approx(actor.vel.x, 0):
		actor.vel.x = x_power * movement.facing_direction
	elif abs(actor.vel.x) < accel_cap:
		actor.vel.x += x_power * movement.facing_direction

	actor.doll.rotation = TAU / 4 + actor.vel.angle()


func _trans_rules():
	if actor.is_on_floor():
		return &"DiveSlide"

	if movement.can_air_action() and Input.is_action_just_pressed(&"down"):
		return [&"GroundPound", true]

	return &""
