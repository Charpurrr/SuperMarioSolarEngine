class_name Jump
extends PlayerState
## Jumping.


@export var jump_power: float = 400.0/63.0
@export var jump_number: int

@export var fall_jump:= &"Fall"

## How many units need to be below you in order to consider freefalling.
const FREEFALL_MARGIN: int = 250

## Check if you've applied variable jump height.
var applied_variation: bool = false


func _on_enter(_handover):
	applied_variation = false
	actor.vel.y = -jump_power

	movement.consec_jumps = jump_number


func _post_tick():
	movement.apply_gravity(-actor.vel.y / jump_power)


func _cycle_tick():
	movement.move_x("air", false)

	if not Input.is_action_pressed(&"jump") and not applied_variation:
		applied_variation = true
		actor.vel.y *= 0.5


func _tell_switch():
	if Input.is_action_just_pressed(&"kick"):
		return &"JumpKick"

	if Input.is_action_just_pressed(&"down"):
		return &"GroundPound"

	if movement.can_wallslide():
		return &"Wallslide"

	if actor.vel.y > 0:
		return fall_jump

	return &""
