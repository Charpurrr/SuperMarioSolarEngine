class_name Dive
extends PlayerState
## General diving state.
## See OdysseyDive for diving after performing a ground pound.


@export var min_x_power: float = 2.0
@export var x_power: float = 6.0
@export var y_power: float = 1.88

## Whether or not you'll go down on your dive.
var down: bool


func _on_enter(_handover):
	if Input.is_action_pressed(&"down"):
		down = true

	movement.consume_coyote_timer()
	movement.consec_jumps = 0

	actor.hitbox.disabled = true
	actor.small_hitbox.disabled = true
	actor.dive_hitbox.disabled = false

	movement.accelerate(x_power, InputManager.get_x(), x_power)
	actor.vel.x = max(min_x_power, abs(actor.vel.x)) * movement.facing_direction

	if is_equal_approx(actor.vel.x, 0):
		actor.vel.y = -y_power

	if not down and actor.vel.y > -y_power:
		actor.vel.y = -y_power


func _cycle_tick():
	movement.body_rotation = actor.vel.angle() + PI / 2

	actor.doll.rotation = lerp_angle(actor.doll.rotation, movement.body_rotation, 0.5)


func _post_tick():
	movement.apply_gravity()


func _on_exit():
	movement.body_rotation = PI/2
	down = false


func _tell_switch():
	if actor.is_on_floor():
		return &"DiveSlide"

	if movement.can_air_action() and Input.is_action_just_pressed(&"down"):
		return &"GroundPound"

	return &""
