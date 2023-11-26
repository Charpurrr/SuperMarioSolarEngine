class_name Jump
extends PlayerState
## Jumping.


## How many units need to be below you in order to consider freefalling.
const FREEFALL_MARGIN: int = 250
const JUMP_POWER: float = 400.0/63.0


func _on_enter(_handover):
	actor.vel.y = -JUMP_POWER


func _post_tick():
	actor.movement.apply_gravity(-actor.vel.y / JUMP_POWER)


func _cycle_tick():
	actor.movement.move_x("air", false)

	if Input.is_action_just_released("jump"):
		actor.vel.y *= 0.5


func _tell_switch():
	if Input.is_action_just_pressed("kick"):
		return &"JumpKick"

	if Input.is_action_just_pressed("down"):
		return &"GroundPound"

	if actor.movement.can_wallslide():
		return &"Wallslide"

	if actor.vel.y > 0:
		return &"Fall"

	return &""
