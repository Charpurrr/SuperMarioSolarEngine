class_name AirDive
extends PlayerState
## Diving while airborne.

@export var x_power: float = 6
@export var y_power: float = 1.5


func _on_enter(_handover):
	movement.consume_coyote_timer()

	actor.hitbox.disabled = true
	actor.small_hitbox.disabled = false

	#actor.vel.x += ((x_power - abs(actor.vel.x)) / 5 * movement.facing_direction)

	movement.accelerate(x_power, input_direction, 6)
	actor.vel.x = max(0.04, abs(actor.vel.x)) * sign(actor.vel.x)

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

	return &""
