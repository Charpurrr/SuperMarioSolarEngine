class_name ButtSlide
extends PlayerState
## Crouching while on a slope (or being forced.)


## Minimum sliding speed.
@export var min_speed: float = 3.0


func _on_enter(_handover):
	actor.hitbox.disabled = true
	actor.small_hitbox.disabled = false


func _cycle_tick():
	if not actor.vel.x >= min_speed:
		movement.accelerate("ground", movement.facing_direction, min_speed)

	if not movement.is_slide_slope():
		movement.decelerate(0.07)


func _on_exit():
	actor.hitbox.disabled = false
	actor.small_hitbox.disabled = true


func _tell_switch():
	if not movement.is_slide_slope():
		return &"Crouch"

	return &""
