class_name SlowTurn
extends PlayerState
## Turning around after a skid.


## How long it takes to accelerate with a slow turn.
@export var turn_accel_time: float = 9
var turn_accel_step: float


func _on_enter(_handover):
	turn_accel_step = movement.max_speed / turn_accel_time
	movement.update_direction(-movement.facing_direction)


func _cycle_tick():
	if input_direction != 0:
		movement.accelerate(turn_accel_step, movement.facing_direction)
	else:
		movement.accelerate(turn_accel_step * 2, movement.facing_direction)


func _tell_switch():
	if is_equal_approx(abs(actor.vel.x), movement.max_speed):
		if input_direction == 0:
			return &"Idle"
		else:
			return &"Walk"

	if Input.is_action_just_pressed(&"jump"):
		return &"Sideflip"

	if Input.is_action_pressed(&"down"):
		return &"Crouch"

	if (input.buffered_input(&"spin") and movement.can_spin()):
		return &"Spin"

	if Input.is_action_just_pressed(&"dive"):
		return &"AirborneDive"

	return &""
