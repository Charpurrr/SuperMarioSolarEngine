class_name Dive
extends PlayerState
## General diving state.
## See OdysseyDive for diving after performing a ground pound.


## The horizontal dive power added to your current velocity.
@export var x_power: float = 6.0
## The vertical dive power only applied in certain cases.
@export var y_power: float = 1.88
## The maximum horizontal speed you need to reach before dives no longer contribute to your x velocity.
@export var accel_cap: float = 10.0


func _on_enter(skip_anim):
	movement.consume_coyote_timer()
	movement.consec_jumps = 0

	if skip_anim == true:
		actor.doll.set_frame(2)

	if actor.vel.y > -y_power or is_equal_approx(actor.vel.x, 0):
		actor.vel.y = -y_power

	if movement.facing_direction != sign(actor.vel.x):
		actor.vel.x = 0

	if is_equal_approx(actor.vel.x, 0):
		actor.vel.x = x_power * movement.facing_direction
	elif abs(actor.vel.x) < accel_cap:
		actor.vel.x += x_power * movement.facing_direction


func _physics_tick():
	movement.body_rotation = actor.vel.angle() + PI / 2

	actor.doll.rotation = lerp_angle(actor.doll.rotation, movement.body_rotation, 0.5)


func _subsequent_ticks():
	movement.apply_gravity()


func _on_exit():
	movement.body_rotation = PI/2


func _trans_rules():
	if actor.is_on_floor():
		return &"DiveSlide"

	if movement.can_air_action() and Input.is_action_just_pressed(&"down"):
		return &"GroundPound"

	return &""
