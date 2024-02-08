class_name Backflip
extends PlayerState
## Jumping while crouching.


@export var jump_power: float = 9.1
## How much the backflip sends you backwards.
@export var push_power: float = 1.4

## If the activate_freefall_timer() function should be called.
var start_freefall_timer: bool = false


func _on_enter(_handover):
	start_freefall_timer = false
	actor.vel.y = -jump_power
	actor.vel.x = push_power * -movement.facing_direction


func _cycle_tick():
	if InputManager.is_moving_x():
		movement.move_x(0.06, false)

	if actor.vel.y > 0 and not start_freefall_timer:
		start_freefall_timer = true

		movement.activate_freefall_timer()


func _post_tick():
	movement.apply_gravity()


func _on_exit():
	actor.doll.rotation = 0


func _play_animation():
	var tween := Tween.new()

	tween.tween_property(actor.doll, actor.doll.rotation, 180 * movement.facing_direction, 1)


func _tell_switch():
	if movement.can_wallslide():
		return &"Wallslide"

	if movement.can_spin() and input.buffered_input(&"spin"):
		return &"Spin"

	if movement.can_air_action() and input.buffered_input(&"dive"):
		return &"AirborneDive"

	if Input.is_action_just_pressed(&"down") and movement.can_air_action():
		return &"GroundPound"

	if actor.is_on_floor():
		return &"BackflipStyle"

	if movement.finished_freefall_timer():
		return &"Freefall"

	return &""

