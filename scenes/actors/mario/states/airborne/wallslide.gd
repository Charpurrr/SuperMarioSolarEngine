class_name Wallslide
extends State
# Holding the facing direction against a wall while airborne


const TERM_VEL : float = 1.10


func on_enter():
	actor.vel.y = min(actor.vel.y, TERM_VEL)


func physics_tick(_delta):
	actor.movement.apply_gravity(1, 8)


func switch_check():
	if actor.movement.should_end_wallslide():
		return get_states().fall

	if actor.movement.active_buffer_jump():
		return get_states().walljump

	if Input.is_action_just_pressed("down"):
		return get_states().groundpound
