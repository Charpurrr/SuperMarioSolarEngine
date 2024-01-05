class_name Walljump
extends PlayerState
## Jumping from a wallslide.


@export var jump_power: float = 8.15
## How much the walljump sends you forwards.
@export var push_power: float = 3


func _on_enter(_handover):
	movement.last_wall = movement.facing_direction

	movement.update_direction(-movement.facing_direction)
	movement.activate_freefall_timer()

	actor.vel.y = -jump_power
	actor.vel.x = push_power * movement.facing_direction

	movement.consec_jumps = 1


func _cycle_tick():
	var should_flip: bool

	should_flip = actor.vel.y > 0

	if InputManager.get_x_dir() != movement.facing_direction:
		movement.move_x(0.13, should_flip)
	elif InputManager.is_moving_x():
		movement.move_x("air", should_flip)

	movement.apply_gravity(-actor.vel.y / jump_power)
	movement.decelerate(0.01)


func _tell_switch():
	if input.buffered_input(&"spin"):
		if movement.last_wall != -movement.facing_direction:
			return &"Spin"
		else:
			return &"Twirl"

	if Input.is_action_just_pressed(&"dive") and movement.can_air_action():
		return &"AirborneDive"

	if Input.is_action_just_pressed(&"down") and movement.can_air_action():
		return &"GroundPound"

	if movement.can_wallslide(true):
		return &"Wallslide"

	if movement.finished_freefall_timer():
		return &"Freefall"

	return &""
