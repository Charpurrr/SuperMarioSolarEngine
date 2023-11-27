class_name StopSkid
extends PlayerState
## Stopping from grounded movement at max speed.


## How long it takes to decelerate from a skid.
const SKID_DECEL_TIME: float = 16
var skid_decel_step: float


func _on_enter(_handover):
	skid_decel_step = movement.MAX_SPEED_X / SKID_DECEL_TIME


func _cycle_tick():
	movement.decelerate(skid_decel_step)


func _tell_switch():
	if actor.vel.x == 0:
		if input_direction == 0:
			return &"Idle"
		else:
			return &"Walk"
	elif input_direction == -movement.facing_direction:
		return &"TurnSkid"

	if Input.is_action_just_pressed(&"jump"):
		return &"DummyJump"

	return &""
