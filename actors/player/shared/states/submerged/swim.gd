class_name Swimming
extends PlayerState
## Moving around underwater.

@export var swimming_speed: float
@export var swimming_accel_time: int


func _physics_tick():
	movement.accelerate(InputManager.get_vec(), swimming_speed)


func _trans_rules():
	if not InputManager.is_moving_any():
		return &"SwimIdle"

	return &""
