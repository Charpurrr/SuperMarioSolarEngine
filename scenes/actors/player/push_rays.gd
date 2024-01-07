class_name PushRays
extends Node2D
## A ray to check for pushable solid bodies


@export var movement: PMovement

@onready var ray_r: RayCast2D = $PushRayR
@onready var ray_l: RayCast2D = $PushRayL

var pushing: bool = false


func _physics_process(_delta):
	match movement.facing_direction:
		1:
			if ray_r.is_colliding():
				pushing = true
			else:
				pushing = false
		-1:
			if ray_l.is_colliding():
				pushing = true
			else:
				pushing = false
