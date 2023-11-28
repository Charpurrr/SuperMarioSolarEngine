class_name Dive
extends PlayerState
## Diving during a jump (or held jump).


const DIVE_POWER: float = 6


func _on_enter(_handover):
	movement.consume_coyote_timer()

	actor.vel.x += 6 * movement.facing_direction


func _tell_switch():
	return &""
