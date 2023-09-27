class_name TurnSkid
extends State
# Turning from grounded movement at max speed


const SKID_DECEL_TIME : float = 16 # How long it takes to decelerate from a skid
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
			return get_states().idle
		elif input_direction == actor.movement.facing_direction:
			return get_states().walk 
		else:
			return get_states().slow_turn

	if Input.is_action_just_pressed("jump"):
		return %Sideflip

	return null
