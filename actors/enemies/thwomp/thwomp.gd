class_name Thwomp
extends AnimatableBody2D


@export var rest_time: int = 20
var rest_timer: int

var falling: bool = false


func _physics_process(_delta):
	if not falling:
		rest_timer = max(rest_timer - 1, 0)
	else:
		constant_linear_velocity = Vector2(0, 600)

		rest_timer = rest_time

	if rest_timer == 0:
		falling = true

	if constant_linear_velocity == Vector2(0, 0):
		print("aaa")
