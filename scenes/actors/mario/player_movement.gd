class_name PMovement
extends Node
# Movement for player characters


@export var actor : Player

# x variables
const MAX_SPEED_X : float = 3 # Max horizontal speed

const GROUND_ACCEL_TIME : float = 25 # How long it takes to accelerate (when grounded)
const GROUND_ACCEL_STEP : float = MAX_SPEED_X / GROUND_ACCEL_TIME

const GROUND_DECEL_TIME : float = 15 # How long it takes to decelerate (when grounded)
const GROUND_DECEL_STEP : float = MAX_SPEED_X / GROUND_DECEL_TIME

const AIR_ACCEL_TIME : float = 25 # How long it takes to accelerate (when airborne)
const AIR_ACCEL_STEP : float = MAX_SPEED_X / AIR_ACCEL_TIME

const AIR_DECEL_TIME : float = 15 # How long it takes to decelerate (when airborne)
const AIR_DECEL_STEP : float = MAX_SPEED_X / AIR_DECEL_TIME

const CELS : Dictionary = {
	"ground": 
	{
		"accel":
			GROUND_ACCEL_STEP,
		"decel":
			GROUND_DECEL_STEP,
	},
	"air": 
	{
		"accel":
			AIR_ACCEL_STEP,
		"decel":
			AIR_DECEL_STEP,
	},
} # List of different types of acceleration/deceleration values

var facing_direction : float = 1

# y variables
const GRAVITY : float = 0.08
const TERM_VEL : float = 6.00


func accelerate(accel_val : Variant, direction : float):
	var accel : float

	if (accel_val is float or accel_val is int):
		accel = accel_val
	elif accel_val is String:
		accel = CELS[accel_val].accel
	else:
		push_error("Not a float or string!")

	if actor.vel.x * direction + accel < MAX_SPEED_X:
		actor.vel.x += direction * accel
	elif actor.vel.x * direction < MAX_SPEED_X:
		actor.vel.x = direction * MAX_SPEED_X


func decelerate(decel_val : Variant):
	var decel : float

	if decel_val is float:
		decel = decel_val
	elif decel_val is String:
		decel = CELS[decel_val].decel
	else:
		push_error("Not a float or string!")

	actor.vel.x = move_toward(actor.vel.x, 0, decel)


func move_x(accel_val : Variant, should_flip : bool): # Handles movement on the X axis
	var input_direction : float = get_input_x()

	if should_flip:
		@warning_ignore("narrowing_conversion")
		update_direction(input_direction)

	accelerate(accel_val, input_direction)


func update_direction(direction : int): # Update facing_direction
	var new_direction = sign(direction)

	if new_direction == 0:
		return

	if facing_direction != new_direction:
		actor.doll.offset.x = -actor.doll.offset.x

	facing_direction = new_direction
	actor.doll.flip_h = (facing_direction == -1)


func check_accessible_space(delta : Vector2) -> bool: # Checks if the space at a position can be moved into
	var collision := KinematicCollision2D.new()

	if actor.test_move(actor.transform, delta, collision):
		return collision.get_normal().dot(Vector2.UP) > 0.5
	else:
		return true


func check_space_ahead() -> bool: # Check if there is accessible space in front of the player
	return check_accessible_space(Vector2(facing_direction, 0))


func get_input_x() -> float:
	return Input.get_axis("left", "right")


func move_y():
	pass


func apply_gravity():
	if actor.vel.y + GRAVITY < TERM_VEL:
		actor.vel.y += GRAVITY
	elif actor.vel.y < TERM_VEL:
		actor.vel.y = TERM_VEL
