class_name Dive
extends PlayerState
## General diving state.

## The horizontal dive power added to your current velocity.
@export var x_power: float = 6.0
## The vertical dive power only applied in certain cases.
@export var y_power: float = 1.88
## The maximum horizontal speed you need to reach before dives no longer
## contribute to your x velocity.
@export var accel_cap: float = 10.0


func _on_enter(bellyflop):
	movement.consume_coyote_timer()
	movement.consec_jumps = 0
	movement.dived = true

	actor.set_floor_snap_length(movement.snap_length)

	if bellyflop:
		actor.doll.set_frame(2)

	if actor.vel.y > -y_power or is_equal_approx(actor.vel.x, 0):
		actor.vel.y = -y_power

	if movement.facing_direction != sign(actor.vel.x):
		actor.vel.x = 0

	#if abs(actor.vel.x) > accel_cap - x_power:
			#actor.vel.x = accel_cap * movement.facing_direction
		#else:
			#actor.vel.x += x_power * movement.facing_direction

	# Sprite rotation starts at 0 when neutral, 
	# which actually corresponds with 90° or PI / 2.
	# To get around this problem we use the 
	# opposite complement of the velocity angle:
	# (TAU / 4 - alpha)
	actor.doll.rotation = TAU / 4 + actor.vel.angle()


func _physics_tick():
	if not actor.is_on_floor():
		movement.body_rotation = TAU / 4 + actor.vel.angle()

	movement.move_x_analog(0.1, false, 0.0, accel_cap)

	actor.doll.rotation = lerp_angle(actor.doll.rotation, movement.body_rotation, 0.5)


func _subsequent_ticks():
	movement.apply_gravity()


func _on_exit():
	actor.doll.rotation = 0


func _trans_rules():
	if actor.is_on_floor():
		return &"DiveSlide"

	if actor.push_rays.is_colliding() or actor.is_on_wall():
		return &"Bonk"

	if movement.can_air_action() and Input.is_action_just_pressed(&"groundpound"):
		return &"GroundPound"

	return &""
