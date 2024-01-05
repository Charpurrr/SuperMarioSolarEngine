class_name TurnSkid
extends PlayerState
## Turning from grounded movement at max speed.


## How long it takes to accelerate from a skid.
@export var skid_accel_time: float = 16
@onready var skid_accel_step: float

## How much the skid should accelerate over max_speed
@export var over_accel: float = 0.3


func _on_enter(starting_frame):
	movement.update_direction(-movement.facing_direction)

	actor.doll.frame = starting_frame
	actor.vel.x = 0

	skid_accel_step = (movement.max_speed + over_accel) / skid_accel_time


func _cycle_tick():
	movement.accelerate(skid_accel_step, movement.facing_direction, movement.max_speed + over_accel)


func _tell_switch():
	if not InputManager.is_moving_x() or actor.vel.x == 0:
		return &"Idle"

	if InputManager.get_x_dir() == -movement.facing_direction:
		reset_state(0)

	if is_equal_approx(abs(actor.vel.x), movement.max_speed + over_accel):
		return &"Walk"

	if movement.can_spin() and input.buffered_input(&"spin"):
		return &"Spin"

	if input.buffered_input(&"jump"):
		return &"Sideflip"

	if Input.is_action_pressed(&"down"):
		return &"Crouch"

	if Input.is_action_just_pressed(&"dive"):
		return &"AirborneDive"

	return &""
