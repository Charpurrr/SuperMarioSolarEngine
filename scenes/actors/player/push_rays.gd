class_name PushRays
extends Node2D
## A ray to check for pushable solid bodies


@export var movement: PMovement

@onready var ray_r: RayCast2D = $PushRayR
@onready var ray_l: RayCast2D = $PushRayL


func is_colliding() -> bool:
	match movement.facing_direction:
		1: return ray_r.is_colliding()
		-1: return ray_l.is_colliding()

	return false
