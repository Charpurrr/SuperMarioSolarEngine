class_name AirDive
extends PlayerState
## Diving while airborne.


@export var min_x_power: float = 2.0
@export var x_power: float = 6.0
@export var y_power: float = 1.88


func _on_enter(_handover):
	movement.consume_coyote_timer()
	movement.consec_jumps = 0

	actor.hitbox.disabled = true
	actor.small_hitbox.disabled = false

	movement.accelerate(x_power, input_direction, x_power)
	actor.vel.x = max(min_x_power, abs(actor.vel.x)) * movement.facing_direction

	actor.vel.y = -y_power


func _cycle_tick():
	movement.body_rotation = actor.vel.angle() + PI / 2

	actor.doll.rotation = lerp_angle(actor.doll.rotation, movement.body_rotation, 0.5)


func _post_tick():
	movement.apply_gravity()


func _on_exit():
	actor.hitbox.disabled = false
	actor.small_hitbox.disabled = true

	movement.body_rotation = 0
	actor.doll.rotation = 0

func _tell_switch():
	#if actor.is_on_floor():
		#return &"DiveSlide"

	if Input.is_action_just_pressed(&"down") and movement.can_air_action():
		return &"GroundPound"

	return &""
