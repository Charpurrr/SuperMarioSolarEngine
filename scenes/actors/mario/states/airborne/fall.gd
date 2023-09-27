class_name Fall
extends State
# Falling state


@onready var idle_state : State = %Idle

const FREEFALL_TIME : int = 70
var freefall_timer : int


func on_enter():
	freefall_timer = FREEFALL_TIME


func physics_tick(_delta):
	freefall_timer = max(freefall_timer - 1, 0)

	actor.movement.move_x("air", false)
	actor.movement.apply_gravity()


func switch_check():
	if Input.is_action_just_pressed("kick"):
		return get_states().jumpkick

	if actor.is_on_floor() and actor.movement.active_buffer_jump():
		return get_states().jump

	if Input.is_action_just_pressed("down"):
		return get_states().groundpound

	if actor.movement.can_wallslide():
		return get_states().wallslide

	if is_equal_approx(actor.vel.y, actor.movement.TERM_VEL) and freefall_timer == 0:
		return get_states().freefall
