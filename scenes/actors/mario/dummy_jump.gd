class_name DummyJump
extends PlayerState
## General jump action.


func _tell_defer():
	print(movement.consec_jumps)
	if not movement.active_consec_time():
		return &"Jump"

	match movement.consec_jumps:
		2:
			if abs(actor.vel.x) > 1:
				return &"TripleJump"
			else:
				return &"DoubleJump"
		1:
			print("doubld")
			return &"DoubleJump"
		_:
			return &"Jump"
