class_name CrouchWalkState
extends State
# Walking while crouching

const MAX_SPEED_X : float = 1 # Max horizontal speed during a crouch walk


@onready var crouch_state = %Crouch
@onready var idle_state = %Idle


func on_enter():
	actor.crouchbox.disabled = false
	actor.hitbox.disabled = true


func on_exit():
	actor.crouchbox.disabled = true
	actor.hitbox.disabled = false


func physics_tick(_delta):
	var input_direction : float = actor.movement.get_input_x()

	actor.vel.x = MAX_SPEED_X * input_direction
	actor.movement.update_direction(input_direction)


func switch_check():
	var input_direction : float = actor.movement.get_input_x()

	if input_direction == 0:
		return crouch_state

	if (not Input.is_action_pressed("down")) and (not actor.crouch_lock.has_overlapping_bodies()):
		return idle_state
