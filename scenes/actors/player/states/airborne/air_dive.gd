class_name Dive
extends PlayerState
## General diving state.
## See OdysseyDive for diving after performing a ground pound.


@export var min_x_power: float = 2.0
@export var x_power: float = 6.0
@export var y_power: float = 1.88

## Whether or not you'll do a faceplant dive.
var down: bool


func _on_enter(_handover):
	if Input.is_action_pressed(&"down"):
		down = true

	movement.consume_coyote_timer()
	movement.consec_jumps = 0

	if (not down and actor.vel.y > -y_power) or is_equal_approx(actor.vel.x, 0):
		actor.vel.y = -y_power


func _physics_tick():
	movement.body_rotation = actor.vel.angle() + PI / 2

	actor.doll.rotation = lerp_angle(actor.doll.rotation, movement.body_rotation, 0.5)


func _subsequent_ticks():
	movement.apply_gravity()


func _on_exit():
	movement.body_rotation = PI/2
	down = false


func _trans_rules():
	if actor.is_on_floor():
		return &"DiveSlide"

	if movement.can_air_action() and Input.is_action_just_pressed(&"down"):
		return &"GroundPound"

	return &""
