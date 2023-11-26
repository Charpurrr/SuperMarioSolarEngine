class_name SlowTurn
extends PlayerState
## Turning around after a skid.


## How long it takes to accelerate with a slow turn.
const TURN_ACCEL_TIME: float = 9
var turn_accel_step: float


func _on_enter(_handover):
	turn_accel_step = actor.movement.MAX_SPEED_X / TURN_ACCEL_TIME
	actor.movement.update_direction(-actor.movement.facing_direction)


func _cycle_tick():
	if input_direction != 0:
		actor.movement.accelerate(turn_accel_step, actor.movement.facing_direction)
	else:
		actor.movement.accelerate(turn_accel_step * 2, actor.movement.facing_direction)


func _tell_switch():
	if is_equal_approx(abs(actor.vel.x), actor.movement.MAX_SPEED_X):
		if input_direction == 0:
			return &"Idle"
		else:
			return &"Walk"

	if Input.is_action_just_pressed("jump"):
		return &"Sideflip"

	return &""
