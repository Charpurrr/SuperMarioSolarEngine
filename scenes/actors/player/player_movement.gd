class_name PMovement
extends Node
## Movement for player characters.


@export var actor: Player

#region X Variables
## Max horizontal speed.
@export var max_speed: float = 2.8

## How long it takes to accelerate (when grounded.)
@export var ground_accel_time: float = 22.5
@onready var ground_accel_step: float = max_speed / ground_accel_time

## How long it takes to decelerate (when grounded.)
@export var ground_decel_time: float = 13.5
@onready var ground_decel_step: float = max_speed / ground_decel_time

## How long it takes to accelerate (when airborne.)
@export var air_accel_time: float = 20
@onready var air_accel_step: float = max_speed / air_accel_time

## How long it takes to decelerate (when airborne.)
# Currently unused in this version of the engine, but could be
# implemented to be used with air resistance.
@export var air_decel_time: float = 18
@onready var air_decel_step: float = max_speed / air_decel_time

## List of different types of acceleration/deceleration values.
@onready var cels: Dictionary = {
	"ground": 
	{
		"accel":
			ground_accel_step,
		"decel":
			ground_decel_step,
	},
	"air": 
	{
		"accel":
			air_accel_step,
		"decel":
			air_decel_step,
	},
}

## How many frames have to progress before you can accelerate forward again.
# Has some nieche use-cases, in-engine is only used to handle wallbonk spins.
@export var return_res: float = 15
var return_res_prog: float

#endregion

#region Y Variables
## Max vertical speed.
@export var term_vel: float = 6.60

## How high gravity can interpolate.
@export var max_grav: float = 0.27
## How low gravity can interpolate.
@export var min_grav: float = 0.26

## Amount of units the player needs to be above the ground to perform an airborne action.
const AIR_MARGIN: int = 10
#endregion

#region Timer Variables
const COYOTE_TIME: int = 7
var coyote_timer: int

const CONSEC_JUMP_TIME: int = 10
var consec_jump_timer: int

const GROUND_SPIN_COOLDOWN_TIME: int = 20
var ground_spin_cooldown_timer: int

const FREEFALL_TIME: int = 100
var freefall_timer: int = -1
#endregion

## Minimum angle of slope needed to start a buttslide.
@export var slide_angle: float = 0.61
## Minimum angle of slope needed to be considered a steep slope.
@export var steep_angle: float = 0.87

var facing_direction: int = 1
## facing_direction on the previous frame.
var prev_facing_direction: int

## If you've performed an airborne spin or not.
var air_spun: bool = false

## Amount of consecutive jumps performed for a triple jump.
var consec_jumps: int = 0

## The player body rotation.
var body_rotation: float = 0


func _physics_process(_delta):
	ground_spin_cooldown_timer = max(ground_spin_cooldown_timer - 1, 0)
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
			consume_coyote_timer()
		# Falling
		elif actor.vel.y > 0:
			freefall_timer = max(freefall_timer - 1, -1)


#region X Functions
func accelerate(accel_val: Variant, direction: float, speed_cap: float = max_speed):
	var accel: float

	if (accel_val is float or accel_val is int):
		accel = accel_val
	elif accel_val is String:
		accel = cels[accel_val].accel
	else:
		push_error("Not a number or string!")

	accel *= (1 - return_res_prog / return_res)

	if actor.vel.x * direction + accel < speed_cap:
		actor.vel.x += direction * accel
	elif actor.vel.x * direction < speed_cap:
		actor.vel.x = direction * speed_cap


func decelerate(decel_val: Variant):
	var decel: float

	if decel_val is float:
		decel = decel_val
	elif decel_val is String:
		decel = cels[decel_val].decel
	else:
		push_error("Not a float or string!")

	actor.vel.x = move_toward(actor.vel.x, 0, decel)


## Handles movement on the X axis.
func move_x(accel_val: Variant, should_flip: bool, speed_cap: float = max_speed):
	var input_direction: float = InputManager.get_x()

	if should_flip:
		update_direction(sign(input_direction))

	accelerate(accel_val, input_direction, speed_cap)


func update_direction(direction: int):
	var new_direction = sign(direction)

	if new_direction == 0:
		return

	if facing_direction != new_direction:
		actor.doll.offset.x = -actor.doll.offset.x

	facing_direction = new_direction
	actor.doll.flip_h = (facing_direction == -1)


func update_prev_direction():
	prev_facing_direction = facing_direction


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
#endregion


#region Y Functions
func apply_gravity(gravity_weight: float = 1, friction: float = 1):
	var gravity = lerpf(min_grav, max_grav, gravity_weight) / friction

	if actor.vel.y + gravity < term_vel:
		actor.vel.y += gravity
	elif actor.vel.y < term_vel:
		actor.vel.y = term_vel
#endregion


#region Timer Functions
## Activate the consecutive jump timer.
func activate_consec_timer() -> void:
	consec_jump_timer = CONSEC_JUMP_TIME


## Return whether the consecutive jump timer is or isn't running.
func active_consec_time() -> bool:
	return consec_jump_timer > 0


## Consume the consecutive jump timer, ridding of any chance at a consecutive jump.
func consume_consec_timer() -> void:
	consec_jump_timer = -1


## Activate the coyote timer.
func activate_coyote_timer() -> void:
	coyote_timer = COYOTE_TIME


## Return whether the coyote timer is or isn't running.
func active_coyote_time() -> bool:
	return coyote_timer > 0


## Consume the coyote timer, ridding of any chance at a coyote input.
func consume_coyote_timer() -> void:
	coyote_timer = 0


## Activate the freefall timer.
func activate_freefall_timer() -> void:
	freefall_timer = FREEFALL_TIME


## Return whether the freefall timer has finished or not.
func finished_freefall_timer() -> bool:
	return freefall_timer == 0


## Consume the freefall timer, ridding of any chance at freefalling.
func consume_freefall_timer() -> void:
	freefall_timer = -1


## Activate the grounded spin cooldown timer.
func activate_grounded_spin_timer() -> void:
	ground_spin_cooldown_timer = GROUND_SPIN_COOLDOWN_TIME


## Return whether the grounded spin timer cooldown has finished or not.
func finished_grounded_spin_timer() -> bool:
	return ground_spin_cooldown_timer == 0


## Consume the grounded spin cooldown timer, making you able to perform a grounded spin immediately.
func consume_grounded_spin_timer() -> void:
	ground_spin_cooldown_timer = 0
#endregion


#region Check Functions
## Check if the slope below the player is a slidable one (in radians.)
func is_slide_slope() -> bool:
	return actor.get_floor_angle() >= slide_angle


## Check if the slope below the player is a steep one (in radians.)
func is_steep_slope() -> bool:
	return actor.get_floor_angle() >= steep_angle


## Whether or not the jump can be variated (released).
func can_release_jump(applied_variation: bool, min_jump_power: float) -> bool:
	return (not Input.is_action_pressed(&"jump") 
	and actor.vel.y > -min_jump_power
	and not applied_variation 
	and actor.vel.y < 0)


## Return whether you can or can't wallslide.
func can_wallslide(ignore_input: bool = false) -> bool:
	if should_end_wallslide(): return false

	return actor.vel.y != 0 and (true if ignore_input else get_input_x() == facing_direction)


## Return whether or not a wallslide should end.
func should_end_wallslide() -> bool:
	if (not actor.push_rays.check_push() or get_input_x() == -facing_direction): return true

	return false


## Return whether or not you can perform a spin attack.
func can_spin() -> bool:
	return can_air_action() or finished_grounded_spin_timer()


## Return whether or not you can perform an airborne action.
## Avoids accidental air movement inputs.
func can_air_action() -> bool:
	return not actor.test_move(actor.transform, Vector2i(0, AIR_MARGIN))
#endregion
