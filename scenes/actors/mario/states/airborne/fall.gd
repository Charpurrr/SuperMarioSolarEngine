class_name FallState
extends State
# Falling state


@onready var idle_state : State = %Idle

const FREEFALL_MARGIN : int = 250
var can_freefall : bool # Check if you can go into freefall


func on_enter():
	can_freefall = !actor.test_move(actor.transform, Vector2(0, FREEFALL_MARGIN))


func physics_tick(_delta):
	actor.movement.move_x("air", false)
	actor.movement.apply_gravity()


func switch_check():
	if actor.is_on_floor():
		return idle_state

	if is_equal_approx(actor.vel.y, actor.movement.TERM_VEL) and can_freefall:
		return get_states().freefall
