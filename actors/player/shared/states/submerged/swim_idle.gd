class_name IdleSubmerged
extends PlayerState
## Staying stationary underwater.

## How long it takes to get to a standstill. (in frames)
@export var decel_time: int
var decel_timer: int

## The vector of the velocity the player entered the water with.
var entered_vel_vec: Vector2


func _on_enter(_param):
	entered_vel_vec = actor.vel
	decel_timer = decel_time


func _physics_tick():
	if decel_timer != 0:
		actor.vel -= entered_vel_vec / decel_time
		decel_timer -= 1


func _trans_rules():
	if InputManager.is_moving_any():
		return &"Swim"

	return &""
