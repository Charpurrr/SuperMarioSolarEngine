class_name PMovement
extends Node
## Movement for player characters.


@export var actor: Player

# X VARIABLES

## Max horizontal speed
const MAX_SPEED_X: float = 2.72

## How long it takes to accelerate (when grounded)
const GROUND_ACCEL_TIME: float = 22.5
const GROUND_ACCEL_STEP: float = MAX_SPEED_X / GROUND_ACCEL_TIME

## How long it takes to decelerate (when grounded)
const GROUND_DECEL_TIME: float = 13.5
const GROUND_DECEL_STEP: float = MAX_SPEED_X / GROUND_DECEL_TIME

## How long it takes to accelerate (when airborne)
const AIR_ACCEL_TIME: float = 18
const AIR_ACCEL_STEP: float = MAX_SPEED_X / AIR_ACCEL_TIME

## How long it takes to decelerate (when airborne)
const AIR_DECEL_TIME: float = 20
const AIR_DECEL_STEP: float = MAX_SPEED_X / AIR_DECEL_TIME

## List of different types of acceleration/deceleration values
const CELS: Dictionary = {
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
}

## Resistance factor for acceleration
const RETURN_RES: float = 15
## Progression for the resistance factor
var return_res_prog: float

var facing_direction: int = 1

# Y VARIABLES

const TERM_VEL: float = 6.60

## (0.251953-) How high gravity can interpolate
const MAX_GRAV: float = 1000.0/3969.0
## How low gravity can interpolate
const MIN_GRAV: float = 990.0/3969.0

const COYOTE_TIME: int = 7
var coyote_timer: int

var consec_jumps: int = 0

const CONSEC_JUMP_TIME: int = 10
var consec_jump_timer: int

var wallslide_disabled: bool

const FREEFALL_TIME: int = 70
var freefall_timer: int = -1


func _physics_process(_delta):
	return_res_prog = max(return_res_prog - 1, 0)

	# Grounded
	if actor.is_on_floor():
		consec_jump_timer = max(consec_jump_timer - 1, -1)

		if consec_jump_timer == 0:
			consec_jumps = 0
	# Airborne
	else:
		coyote_timer = max(coyote_timer - 1, 0)

	# Rising
	if actor.vel.y < 0:
		coyote_timer = 0
	# Falling
	elif actor.vel.y > 0:
		freefall_timer = max(freefall_timer - 1, -1)

# X FUNCTIONS

func accelerate(accel_val: Variant, direction: float):
	var accel: float

	if (accel_val is float or accel_val is int):
		accel = accel_val
	elif accel_val is String:
		accel = CELS[accel_val].accel
	else:
		push_error("Not a number or string!")

	accel *= (1 - return_res_prog / RETURN_RES)

	if actor.vel.x * direction + accel < MAX_SPEED_X:
		actor.vel.x += direction * accel
	elif actor.vel.x * direction < MAX_SPEED_X:
		actor.vel.x = direction * MAX_SPEED_X


func decelerate(decel_val: Variant):
	var decel: float

	if decel_val is float:
		decel = decel_val
	elif decel_val is String:
		decel = CELS[decel_val].decel
	else:
		push_error("Not a float or string!")

	actor.vel.x = move_toward(actor.vel.x, 0, decel)


## Handles movement on the X axis.
func move_x(accel_val: Variant, should_flip: bool):
	var input_direction: float = get_input_x()

	if should_flip:
		update_direction(sign(input_direction))

	accelerate(accel_val, input_direction)


## Update facing_direction.
func update_direction(direction: int):
	var new_direction = sign(direction)

	if new_direction == 0:
		return

	if facing_direction != new_direction:
		actor.doll.offset.x = -actor.doll.offset.x

	facing_direction = new_direction
	actor.doll.flip_h = (facing_direction == -1)


## Checks if the space at a position can be moved into.
func check_accessible_space(delta: Vector2) -> bool:
	var collision := KinematicCollision2D.new()

	if actor.test_move(actor.transform, delta, collision):
		return collision.get_normal().dot(Vector2.UP) > 0.5
	else:
		return true


## Check if there is accessible space in front of the player.
func check_space_ahead() -> bool:
	return check_accessible_space(Vector2(facing_direction, 0))


func get_input_x() -> float:
	return roundf(Input.get_axis("left", "right"))

# Y FUNCTIONS

func apply_gravity(gravity_weight: float = 1, friction: float = 1):
	var gravity = lerpf(MIN_GRAV, MAX_GRAV, gravity_weight) / friction

	if actor.vel.y + gravity < TERM_VEL:
		actor.vel.y += gravity
	elif actor.vel.y < TERM_VEL:
		actor.vel.y = TERM_VEL

# TIMER FUNCTIONS

## Activate the consecutive jump timer.
func activate_consec_jump_timer():
	consec_jump_timer = CONSEC_JUMP_TIME


## Return whether the consecutive jump timer is or isn't running.
func active_consec_time() -> bool:
	return consec_jump_timer > 0


## Activate the coyote timer.
func activate_coyote_timer():
	coyote_timer = COYOTE_TIME


## Return whether the coyote timer is or isn't running.
func active_coyote_time() -> bool:
	return coyote_timer > 0


## Consume the coyote timer, ridding of any chance at a coyote input.
func consume_coyote_timer():
	coyote_timer = 0


## Activate the freefall timer.
func activate_freefall_timer():
	freefall_timer = FREEFALL_TIME


## Return whether the freefall timer has finished or not.
func finished_freefall_timer() -> bool:
	return freefall_timer == 0


## Consume the freefall timer, ridding of any chance at freefalling.
func consume_freefall_timer():
	freefall_timer = -1

# CHECK FUNCTIONS

## Return whether you can or can't wallslide.
func can_wallslide() -> bool:
	if should_end_wallslide():
		return false

	return !wallslide_disabled and actor.vel.y > 0


## Return whether or not a wallslide should end
func should_end_wallslide() -> bool:
	var input_direction: float = get_input_x()

	if not actor.push_ray.is_colliding():
		return true

	if input_direction == -facing_direction:
		return true

	return false
