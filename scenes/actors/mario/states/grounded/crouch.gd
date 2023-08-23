class_name CrouchState
extends State
# Holding down on the floor


func on_enter():
	actor.crouchbox.disabled = false
	actor.hitbox.disabled = true


func on_exit():
	actor.crouchbox.disabled = true
	actor.hitbox.disabled = false


func physics_tick(_delta):
	actor.movement.decelerate("ground")


func switch_check():
	var input_direction : float = actor.movement.get_input_x()

	if not Input.is_action_pressed("down") and not actor.crouch_lock.has_overlapping_bodies() and actor.vel.x == 0:
		return get_states().idle

	if input_direction != 0 and actor.vel.x == 0:
		return get_states().crouch_walk

	if Input.is_action_just_pressed("jump"):
		return %Backflip
