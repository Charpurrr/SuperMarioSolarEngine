class_name Dive
extends PlayerState
## Diving during a jump (or held jump).


const DIVE_POWER: float = 6


func on_enter():
	movement.consume_coyote_timer()

	create_tween().tween_property(actor, "rotation_degrees", 90 * movement.facing_direction, 0.1)
	actor.vel.x += 6 * movement.facing_direction


func switch_check():
	pass
