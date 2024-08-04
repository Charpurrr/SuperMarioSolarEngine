class_name Swimming
extends PlayerState
## Moving around underwater.

@export var swimming_speed: float
@export var swimming_accel_time: int


func _physics_tick():
	var accel_step: float = swimming_speed / float(swimming_accel_time)
	movement.accelerate(InputManager.get_vec() * accel_step, swimming_speed, 0.03125)
	movement.radial_friction(0.0625, swimming_speed)


func _trans_rules():
	if not InputManager.is_moving_any():
		return &"SwimIdle"

	return &""
