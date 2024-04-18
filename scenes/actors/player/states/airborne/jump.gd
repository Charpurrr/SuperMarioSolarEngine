class_name Jump
extends PlayerState
## Jumping.


@export var jump_power: float = 400.0 / 63.0

## How much of the jump needs to be finished before it can be let go.
@export_range(0.00, 100.00) var min_jump_percent: float
var min_jump_power: float

@export var jump_number: int

@export var fall_state:= &"Fall"

## Check if you've applied variable jump height.
var applied_variation: bool = false


func _on_enter(_handover):
	applied_variation = false
	actor.vel.y = -jump_power

	min_jump_power = jump_power * (1 - min_jump_percent / 100)

	movement.consec_jumps = jump_number


func _subsequent_ticks():
	movement.apply_gravity(-actor.vel.y / jump_power)


func _physics_tick():
	movement.move_x("air", true)

	if movement.can_release_jump(applied_variation, min_jump_power):
		applied_variation = true
		actor.vel.y *= 0.5


func _trans_rules():
	if input.buffered_input(&"dive"):
		return [&"Dive", false]

	if movement.can_spin() and input.buffered_input(&"spin"):
		return &"Spin"

	if Input.is_action_just_pressed(&"down") and movement.can_air_action():
		return &"GroundPound"

	if movement.can_wallslide():
		return &"Wallslide"

	if actor.vel.y > 0:
		return fall_state

	return &""
