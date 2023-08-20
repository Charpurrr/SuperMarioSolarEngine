class_name SkidState
extends State
# Stopping from grounded movement at max speed


@onready var slow_turn_state : State = %SlowTurn
@onready var slideflip_state : State = %Sideflip
@onready var idle_state : State = %Idle
@onready var walk_state : State = %Walk

const SKID_DECEL_TIME : float = 18 # How long it takes to decelerate from a skid
var skid_decel_step : float


func _ready():
	await actor.ready

	skid_decel_step = actor.movement.MAX_SPEED_X / SKID_DECEL_TIME


func physics_tick(_delta):
	actor.movement.decelerate(skid_decel_step)


func switch_check():
	var input_direction : float = actor.movement.get_input_x()

	if actor.vel.x == 0:
		if input_direction == 0:
			return idle_state
		elif input_direction == actor.movement.facing_direction:
			return walk_state 
		else:
			return slow_turn_state
	elif Input.is_action_just_pressed("jump"):
		return slideflip_state

	return null
