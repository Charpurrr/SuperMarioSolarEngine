class_name SlowTurn
extends PlayerState
## Turning around after a skid.


## How long it takes to accelerate with a slow turn.
const TURN_ACCEL_TIME: float = 9
var turn_accel_step: float


func _on_enter(_handover):
	turn_accel_step = movement.MAX_SPEED_X / TURN_ACCEL_TIME
	movement.update_direction(-movement.facing_direction)


func _cycle_tick():
	if input_direction != 0:
		movement.accelerate(turn_accel_step, movement.facing_direction)
	else:
		movement.accelerate(turn_accel_step * 2, movement.facing_direction)


func _tell_switch():
	print(actor.vel.x)
	if is_equal_approx(abs(actor.vel.x), movement.MAX_SPEED_X):
		if input_direction == 0:
			return &"Idle"
		else:
			return &"Walk"

	if Input.is_action_just_pressed(&"jump"):
		return &"Sideflip"

	return &""
