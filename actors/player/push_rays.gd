class_name PushRays
extends Node2D
## Rays to check for pushable solid bodies.

@export var movement: PMovement

@onready var ray_r: RayCast2D = $PushRayR
@onready var ray_l: RayCast2D = $PushRayL


func is_colliding(input_based: bool = false, collision_based: bool = false) -> bool:
	var check: int

	if input_based:
		check = InputManager.get_x_dir()
	elif not collision_based:
		check = movement.facing_direction
	else:
		check = get_collide_side()

	match check:
		1:
			return ray_r.is_colliding()
		-1:
			return ray_l.is_colliding()

	return false


## Return whichever wall is being colided with as an integer.
## This includes a priority-like system.
func get_collide_side() -> int:
	var left = ray_l.is_colliding()
	var right = ray_r.is_colliding()

	if not (left or right):
		return 0

	match InputManager.get_x_dir():
		1:
			if right:
				return 1
			else:
				return 0
		-1:
			if left:
				return -1
			else:
				return 0

	match movement.facing_direction:
		1:
			if right:
				return 1
		-1:
			if left:
				return -1

	if right:
		return 1
	elif left:
		return -1

	# Stop complaining.
	return 0
