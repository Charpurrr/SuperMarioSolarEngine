class_name PMovement
extends Node
## Movement for player characters.

@export var actor: Player

#region X Variables
@export_category("X Variables")

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

# Currently unused in this version of the engine, but could be
# implemented to be used with air resistance.
## How long it takes to decelerate (when airborne.)
@export var air_decel_time: float = 18
@onready var air_decel_step: float = max_speed / air_decel_time

## List of different types of acceleration/deceleration values.
@onready var cels: Dictionary = {
	"ground":
	{
		"accel": ground_accel_step,
		"decel": ground_decel_step,
	},
	"air":
	{
		"accel": air_accel_step,
		"decel": air_decel_step,
	},
}

## How many frames have to progress before you can accelerate forward again.
## Has some nieche use-cases, in-engine is only used to handle wallbonk spins.
@export var return_res: float = 15
var return_res_prog: float
#endregion

#region Y Variables
@export_category("Y Variables")

## Max vertical speed.
@export var term_vel: float = 6.60

## How high gravity can interpolate.
@export var max_grav: float = 0.22
## How low gravity can interpolate.
@export var min_grav: float = max_grav

## Amount of units the player needs to be above the ground to perform an airborne action.
@export var air_margin: int = 10

## Sets the floor_snap_length of the actor.
@export var snap_length: float = 16

## The y position of the point you walljumped from.
## Used to avoid being able to scale a wall infinitely.
var walljump_start_y: float
## How many units you need to pass from your original walljump y position
## in order to be turned around. See 'walljump_start_y'.
## Defaulted to roughly the amount of height you can get from a spin.
@export var walljump_turn_threshold: float = 10.0
#endregion

#region Timer Variables
@export_category("Timer Variables")

## How many frames an airborne input is still registered after leaving the ground.
@export var coyote_time: int = 7
var coyote_timer: int

## How many frames can be between consecutive timed jump inputs. (Triple jump)
@export var consec_jump_time: int = 10
var consec_jump_timer: int

@export var ground_spin_cooldown_time: int = 20
var ground_spin_cooldown_timer: int

## How many frames need to pass before you start freefalling out of a normal fall.
@export var freefall_time: int = 100
var freefall_timer: int = -1
#endregion

#region Miscellaneous Variables
@export_category("Miscellaneous Variables")

## Minimum incline of slope (0.0 - 1.0) needed to start a buttslide.
@export_range(0.0, 1.0) var min_slide_incline: float = 0.3
## Minimum incline of slope (0.0 - 1.0) needed to be considered a steep slope.
## Steep slopes automatically make you slide off.
@export_range(0.0, 1.0) var min_steep_incline: float = 0.8

var facing_direction: int = 1
## facing_direction on the previous frame.
var prev_facing_direction: int

## Whether or not you've performed an airborne spin.
var air_spun: bool = false
## Whether or not you've performed an airborne or faceplant dive.
var dived: bool = false

## Amount of consecutive jumps performed for a triple jump.
var consec_jumps: int = 0

## The player body rotation.
var body_rotation: float = 0
#endregion


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
func accelerate(
	accel_val: Variant, direction: float, speed_cap: float = max_speed, analog: float = 1
):
	var accel: float

	if accel_val is float or accel_val is int:
		accel = accel_val
	elif accel_val is String:
		accel = cels[accel_val].accel
	else:
		push_error("Not a number or string!")

	speed_cap *= analog
	accel *= analog

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
	var input_direction: int = InputManager.get_x_dir()

	if should_flip:
		update_direction(input_direction)

	accelerate(accel_val, input_direction, speed_cap)


## Handles movement on the X axis for joystick analog inputs.
func move_x_analog(
	accel_val: Variant, should_flip: bool, friction_val: Variant = 0.0, speed_cap: float = max_speed
):
	var input_direction: float = InputManager.get_x()

	var normalised_input: float = sign(input_direction)
	var analog_input: float = abs(input_direction)

	if should_flip:
		update_direction(int(normalised_input))

	accelerate(accel_val, normalised_input, speed_cap, analog_input)

	if abs(actor.vel.x) > speed_cap * analog_input:
		decelerate(friction_val)


## Updates the player's visual facing direction.
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
	consec_jump_timer = consec_jump_time


## Return whether the consecutive jump timer is or isn't running.
func active_consec_time() -> bool:
	return consec_jump_timer > 0


## Consume the consecutive jump timer, ridding of any chance at a consecutive jump.
func consume_consec_timer() -> void:
	consec_jump_timer = -1


## Activate the coyote timer.
func activate_coyote_timer() -> void:
	coyote_timer = coyote_time


## Return whether the coyote timer is or isn't running.
func active_coyote_time() -> bool:
	return coyote_timer > 0


## Consume the coyote timer, ridding of any chance at a coyote input.
func consume_coyote_timer() -> void:
	coyote_timer = 0


## Activate the freefall timer.
func activate_freefall_timer() -> void:
	freefall_timer = freefall_time


## Return whether the freefall timer has finished or not.
func finished_freefall_timer() -> bool:
	return freefall_timer == 0


## Consume the freefall timer, ridding of any chance at freefalling.
func consume_freefall_timer() -> void:
	freefall_timer = -1


## Activate the grounded spin cooldown timer.
func activate_grounded_spin_timer() -> void:
	ground_spin_cooldown_timer = ground_spin_cooldown_time


## Return whether the grounded spin timer cooldown has finished or not.
func finished_grounded_spin_timer() -> bool:
	return ground_spin_cooldown_timer == 0


## Consume the grounded spin cooldown timer, making you able to perform a grounded spin immediately.
func consume_grounded_spin_timer() -> void:
	ground_spin_cooldown_timer = 0


#endregion


#region Check Functions
## Return the incline of the floor below you, from 0.0 to 1.0.
func get_floor_incline() -> float:
	return angle_difference(-TAU / 4.0, actor.get_floor_angle()) / (TAU / 4.0) - 1


## Check if the slope below the player is a slidable one.
## (A small value is substracted due to floating point precision errors.)
func is_slide_slope() -> bool:
	return get_floor_incline() > min_slide_incline - 0.01


## Check if the slope below the player is a steep one.
## (A small value is substracted due to floating point precision errors.)
func is_steep_slope() -> bool:
	return get_floor_incline() > min_steep_incline - 0.01


## Whether or not the jump can be variated (released).
func can_release_jump(applied_variation: bool, min_jump_power: float) -> bool:
	return (
		not Input.is_action_pressed(&"jump")
		and actor.vel.y > -min_jump_power
		and not applied_variation
		and actor.vel.y < 0
	)


## Return whether you can or can't initiate a wallslide.
## input_based is whether or not a wallslide prioritises input over facing_direction.
func can_init_wallslide(input_based: bool = false) -> bool:
	if should_end_wallslide(input_based):
		return false

	if not actor.vel.y >= 0:
		return false

	return input_based or get_input_x() == facing_direction


## Return whether or not a wallslide should end.
func should_end_wallslide(input_based: bool = false) -> bool:
	if not actor.push_rays.is_colliding(input_based):
		return true
	if not input_based and get_input_x() == -facing_direction:
		return true
	if not can_air_action():
		return true

	return false


## Return whether or not you can perform a spin attack.
func can_spin() -> bool:
	return can_air_action() or finished_grounded_spin_timer()


## Return whether or not you can perform an airborne action.
## Avoids accidental air movement inputs.
func can_air_action() -> bool:
	return not actor.test_move(actor.transform, Vector2i(0, air_margin)) or actor.vel.y < 0


func is_submerged() -> bool:
	return actor.water_detector.has_overlapping_areas()
#endregion
