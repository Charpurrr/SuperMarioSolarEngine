class_name ButtSlide
extends PlayerState
## Crouching while on a slope (or being forced.)


## Minimum sliding speed.
@export var min_speed: float = 3.0


func _physics_tick():
	if not actor.vel.x >= min_speed:
		movement.accelerate("ground", movement.facing_direction, min_speed)

	if not movement.is_slide_slope():
		movement.decelerate(0.07)


func _trans_rules():
	if not movement.is_slide_slope():
		return [&"Crouch", [true, true]]

	return &""
