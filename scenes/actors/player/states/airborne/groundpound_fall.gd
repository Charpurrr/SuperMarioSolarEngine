class_name GroundPoundFall
extends PlayerState
## Falling after performing a ground pound.


## How fast you ground pound.
@export var gp_fall_vel = 9

## Whether or not you're allowed to transition to the FaceplantDive state.
## This is to avoid being able to linger in the air indefinitely using a Down + Dive combo.
var allow_dive: bool


func _on_enter(allow):
	allow_dive = allow


func _physics_tick():
	movement.move_x(0.04, false)
	actor.vel.y = gp_fall_vel


func _trans_rules():
	if actor.is_on_floor():
		return &"GroundPoundLand"

	if allow_dive and movement.can_air_action() and input.buffered_input(&"dive"):
		return &"FaceplantDive"

	if input.buffered_input(&"up"):
		return &"GroundPoundCancel"

	return &""
