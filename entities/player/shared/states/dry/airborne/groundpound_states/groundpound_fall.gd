class_name GroundPoundFall
extends PlayerState
## Falling after performing a ground pound.

## How fast you ground pound.
@export var gp_fall_vel: float = 9.0

func _on_enter(_param):
	actor.foot_hitbox.damage_component.amount = 3

func _on_exit():
	actor.foot_hitbox.damage_component.amount = 1

func _physics_tick():
	movement.move_x_analog(0.04, false)

	actor.vel.y = gp_fall_vel


func _trans_rules():
	if actor.is_on_floor():
		if movement.is_slide_slope():
			return [&"ButtSlide", gp_fall_vel]
		else:
			return &"GroundPoundLand"

	if not movement.dived and movement.can_air_action() and input.buffered_input(&"dive"):
		return &"Dive"

	if input.buffered_input(&"up"):
		return &"GroundPoundCancel"

	return &""
