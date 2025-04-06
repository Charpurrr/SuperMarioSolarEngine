class_name Spin
extends PlayerState
## Spinning for the first time.

## How much the spin sends you upwards when airborne.
@export var spin_power: float = 6

## Whether the spin action was performed while airborne or not.
var is_airspin: bool
## Whether the initial spin action has finished or not.
var finished_init: bool

var nearby_entities: Array = []
var hitbox: Hitbox

func _on_enter(_param):
	is_airspin = movement.can_air_action()
	hitbox = actor.spin_hitbox
	
	actor.spin_hitbox.monitoring = true
	hitbox.disabled = false

	if is_airspin:
		movement.air_spun = true
		actor.vel.y = -spin_power

		if InputManager.get_x_dir() == -sign(actor.vel.x):
			actor.vel.x = 0

	movement.activate_freefall_timer()
	movement.consume_coyote_timer()

	particles[0].emit_at(self, Vector2.ZERO, Vector2(movement.facing_direction, 0))


func _first_tick():
	# Gravity needs to be applied when a grounded spin is buffered.
	# (Pressing the spin actions while being a few units from the ground.)
	if not is_airspin:
		movement.apply_gravity()


func _subsequent_ticks():
	movement.apply_gravity()


func _physics_tick():
	is_airspin = movement.can_air_action()

	if is_airspin:
		movement.move_x_analog(movement.air_accel_step, false)
	else:
		movement.move_x_analog(movement.ground_accel_step, false)

	if not actor.doll.is_playing():
		finished_init = true


func _on_exit():
	actor.spin_hitbox.monitoring = false
	hitbox.disabled = true

	if not is_airspin:
		movement.activate_grounded_spin_timer()

	if actor.is_on_floor():
		movement.update_direction(sign(movement.get_input_x()))

	nearby_entities.clear()
	finished_init = false


func _trans_rules():
	if is_airspin:
		return _air_rules()

	return _ground_rules()


func _air_rules() -> Variant:
	if actor.is_on_floor():
		return &"Idle"
		
	if movement.actor.vel.y > 0:
		hitbox.disabled = true
		
	if movement.can_air_action():
		if finished_init and input.buffered_input(&"spin"):
			return &"Twirl"

		if not movement.dived and input.buffered_input(&"dive"):
			return [&"Dive", InputManager.get_x_dir()]

	if movement.finished_freefall_timer():
		return &"Freefall"

	if Input.is_action_just_pressed(&"groundpound") and movement.can_air_action():
		return &"GroundPound"

	if actor.push_rays.is_colliding() and input.buffered_input(&"jump"):
		return [&"Walljump", -movement.facing_direction]

	if movement.can_init_wallslide():
		return &"Wallslide"

	return &""


func _ground_rules() -> Variant:
	#if actor.is_on_floor():
	if not actor.doll.is_playing():
		return &"Idle"

	if input.buffered_input(&"jump"):
		return &"Spinjump"

	return &""
