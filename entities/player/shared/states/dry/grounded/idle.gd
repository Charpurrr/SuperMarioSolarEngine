class_name Idle
extends PlayerState
## Default grounded state when there is no input.

@export_category(&"Animation (Unique to State)")
@export var animation_look_up: StringName
@export var anim_offset_look_up: Vector2


func _physics_tick():
	movement.update_prev_direction()
	movement.decelerate(movement.ground_decel_step * Vector2.RIGHT)

	if Input.is_action_pressed(&"up"):
		actor.doll.play(animation_look_up)
		actor.doll.offset = anim_offset_look_up
	else:
		actor.doll.play(animation)
		actor.doll.offset = anim_offset


func _trans_rules():
	if actor.vel.x != 0 and input.buffered_input(&"dive"):
		return &"Dive"

	if Input.is_action_pressed(&"down"):
		return [&"Crouch", [false, true]]

	if movement.can_spin() and input.buffered_input(&"spin"):
		return &"Spin"

	if InputManager.get_x_dir() != 0:
		return &"Walk"

	if input.buffered_input(&"jump"):
		return &"DummyJump"

	return &""
