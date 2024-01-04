class_name TurnSkid
extends PlayerState
## Turning from grounded movement at max speed.


## How long it takes to accelerate from a skid.
@export var skid_accel_time: float = 16
@onready var skid_accel_step: float


func _on_enter(_handover):
	movement.update_direction(-movement.facing_direction)
	actor.vel.x = 0

	skid_accel_step = movement.max_speed / skid_accel_time


func _cycle_tick():
	movement.accelerate(skid_accel_step, -movement.facing_direction)


func _tell_switch():
	if input_direction == 0 or actor.vel.x == 0:
		return &"Idle"
	elif input_direction == movement.facing_direction:
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
