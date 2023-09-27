class_name StopSkid
extends State
# Stopping from grounded movement at max speed


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
		else:
			return get_states().walk 
	elif input_direction == -actor.movement.facing_direction:
		return get_states().turn_skid

	if Input.is_action_just_pressed("jump"):
		return %Jump

	return null
