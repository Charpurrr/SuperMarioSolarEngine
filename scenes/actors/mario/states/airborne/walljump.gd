class_name Walljump
extends PlayerState
## Jumping from a wallslide.


@export var jump_power: float = 8.15
## How much the walljump sends you forwards.
@export var push_power: float = 3


func _on_enter(_handover):
	movement.update_direction(-movement.facing_direction)

	actor.vel.y = -jump_power
	actor.vel.x = push_power * movement.facing_direction

	movement.consec_jumps = 1


func _cycle_tick():
	if input_direction != movement.facing_direction:
		movement.move_x(0.13, false)
	elif input_direction != 0:
		movement.move_x("air", false)

	movement.apply_gravity(-actor.vel.y / jump_power)
	movement.decelerate(0.01)


func _tell_switch():
	if actor.vel.y > 0:
		return &"Fall"

	if input.buffered_input(&"spin"):
		return &"Spin"

	if Input.is_action_just_pressed(&"down") and movement.can_groundpound():
		return &"GroundPound"

	return &""
