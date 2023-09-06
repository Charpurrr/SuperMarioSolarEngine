class_name SlowTurnState
extends State
# Turning around after a skid


const TURN_ACCEL_TIME : float = 9 # How long it takes to accelerate with a slow turn
var turn_accel_step : float


func on_enter():
	turn_accel_step = actor.movement.MAX_SPEED_X / TURN_ACCEL_TIME
	actor.movement.update_direction(-actor.movement.facing_direction)


func physics_tick(_delta):
	var input_direction : float = actor.movement.get_input_x()

	if input_direction != 0:
		actor.movement.accelerate(turn_accel_step, actor.movement.facing_direction)
	else:
		actor.movement.accelerate(turn_accel_step * 2, actor.movement.facing_direction)

func switch_check():
	var input_direction : float = actor.movement.get_input_x()

	if is_equal_approx(abs(actor.vel.x), actor.movement.MAX_SPEED_X):
		if input_direction == 0:
			return %Idle
		else:
			return %Walk

	if Input.is_action_just_pressed("jump"):
		return %Sideflip

	return null
