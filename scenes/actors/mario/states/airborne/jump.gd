class_name JumpState
extends State
# Jumping state


@export_group("Sounds", "sfx_")
@export var sfx_alt_sound_effects : Array

const FREEFALL_MARGIN : int = 250
const JUMP_POWER : float = 6.8


func on_enter():
	actor.vel.y = -JUMP_POWER


func physics_tick(_delta):
	actor.movement.move_x("air", false)
	actor.movement.apply_gravity(-actor.vel.y / JUMP_POWER)

	if Input.is_action_just_released("jump"):
		actor.vel.y *= 0.5


func get_sfx():
	if actor.test_move(actor.transform, Vector2(0, FREEFALL_MARGIN)):
		return sfx_sound_effects
	else:
		return sfx_alt_sound_effects


func switch_check():
	if Input.is_action_just_pressed("kick"):
		return get_states().jumpkick

	if Input.is_action_just_pressed("down"):
		return get_states().groundpound

	if actor.movement.can_wallslide():
		return get_states().wallslide

	if actor.vel.y > 0:
		return get_states().fall
