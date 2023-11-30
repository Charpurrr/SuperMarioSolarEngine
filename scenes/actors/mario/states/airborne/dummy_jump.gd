class_name DummyJump
extends PlayerState
## General jump action.


## Minimum X velocity required to perform the third consecutive jump.
const TRIPLE_MIN_VEL : float = 1


func _on_enter(_handover):
	movement.consume_coyote_timer()


func _tell_defer():
	if not movement.active_consec_time():
		return &"Jump"

	match movement.consec_jumps:
		2:
			if abs(actor.vel.x) > TRIPLE_MIN_VEL and sign(actor.vel.x) == movement.facing_direction:
				return &"TripleJump"
			else:
				return &"DoubleJump"
		1:
			return &"DoubleJump"
		_:
			return &"Jump"
