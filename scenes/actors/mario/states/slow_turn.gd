class_name SlowTurnState
extends State
# Turning around after a skid


@onready var idle_state : State = %Idle
@onready var walk_state : State = %Walk
@onready var jump_state : State = %Jump

const TURN_ACCEL_TIME : float = 20 # How long it takes to accelerate with a slow turn
var turn_accel_step : float


func _ready():
	await actor.ready

	turn_accel_step = actor.movement.MAX_SPEED_X / TURN_ACCEL_TIME


func on_enter():
	actor.movement.update_direction(-actor.movement.facing_direction)


func physics_tick(_delta):
	actor.movement.accelerate(turn_accel_step, actor.movement.facing_direction)


func switch_check():
	var input_direction : float = actor.movement.get_input_x()

	if abs(actor.vel.x) == actor.movement.MAX_SPEED_X:
		if input_direction == 0:
			return idle_state
		else:
			return walk_state 
	elif Input.is_action_just_pressed("jump"):
		return jump_state

	return null
