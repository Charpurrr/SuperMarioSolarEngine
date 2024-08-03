class_name Swimming
extends PlayerState
## Moving around underwater.

@export var swimming_speed: float
@export var swimming_accel_time: int


func _physics_tick():
	actor.vel = InputManager.get_vec() * swimming_speed


#func _accelerate(accel_val: Variant, direction: Vector2):
	#if actor.vel.dot(direction) + accel_val < swimming_speed:
		#actor.vel += direction * accel_val
	#elif actor.vel.dot(direction) < swimming_speed:
		#actor.vel = direction * swimming_speed


func _trans_rules():
	if not InputManager.is_moving_any():
		return &"SwimIdle"

	return &""
