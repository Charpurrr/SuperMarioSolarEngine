class_name Dive
extends PlayerState
## Diving forward (BETTER DESCRIPTION NEEDED).


const DIVE_POWER: float = 6


func _on_enter(_handover):
	movement.consume_coyote_timer()

	actor.hitbox.disabled = true
	actor.small_hitbox.disabled = false

	movement.body_rotation = actor.vel.angle() + PI / 2 * (1 - movement.facing_direction)


func _on_exit():
	actor.hitbox.disabled = false
	actor.small_hitbox.disabled = true


func _tell_switch():
	if actor.is_on_floor():
		return &"DiveSlide"

	return &""
