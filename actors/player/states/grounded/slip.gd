class_name Slip
extends PlayerState
## An attempt to implement slipping Slipping from a steep slope.
## Mostly made up of remixed sliding and diving code spliced together.

@export var slip_accel: float = 0.5
@export var max_slip_speed: float = 15
@export var slip_friction: float = 0.05

var slip_speed: float = 0.0

func _on_enter(_handover):
	slip_speed = 0.0
	actor.floor_stop_on_slope = false
	actor.doll.rotation = movement.body_rotation


func _physics_tick():
	var normal_angle: float = actor.get_floor_normal().angle()
	var angle: float = normal_angle + TAU / 2 * Math.sign_positive(movement.facing_direction)

	actor.doll.rotation = lerp_angle(actor.doll.rotation, angle, 0.5)

	_modify_speed()


func _on_exit():
	actor.floor_stop_on_slope = true
	actor.doll.rotation = 0


func _modify_speed():
	if movement.is_steep_slope():
		_accelerate(slip_accel, max_slip_speed)
	elif !movement.is_steep_slope():
		movement.decelerate(slip_friction)


func _accelerate(amount: Variant, speed_cap: float):
	var floor_normal: Vector2 = actor.get_floor_normal()
	var slip_direction: Vector2
	slip_direction = _get_slip_dir(floor_normal)
	
	if slip_speed + amount < speed_cap:
		slip_speed += amount
	elif slip_speed > speed_cap:
		slip_speed = speed_cap

	actor.vel = slip_direction * slip_speed
	actor.vel.y += 0.1


## Get the slide direction downwards along the slope.
func _get_slip_dir(floor_normal: Vector2) -> Vector2:
	var direction: Vector2

	if floor_normal == Vector2.UP:
		# On flat ground, just go right.
		direction = Vector2.RIGHT
	else:
		direction = floor_normal.orthogonal()

		if direction.dot(Vector2.DOWN) < 0:
			direction = -direction

	return direction


func _trans_rules():
	if !movement.is_steep_slope():
		if not actor.crouchlock.enabled:
			if movement.can_spin() and input.buffered_input(&"spin"):
				return &"Spin"

			if input.buffered_input(&"dive"):
				return [&"Dive", true]

			if (
				(InputManager.get_x_dir() == movement.facing_direction 
				or InputManager.get_x_dir() == 0)
				and (input.buffered_input(&"jump") 
				or Input.is_action_pressed(&"jump"))
			):
				return &"Rollout"

		if Input.is_action_pressed(&"down"):
			if movement.is_slide_slope():
				return &"ButtSlide"

			return [&"Crouch", [true, false]]

		if is_zero_approx(actor.vel.x) or InputManager.get_x_dir() == -movement.facing_direction:
			if actor.crouchlock.enabled:
				return [&"Crouch", [true, false]]

			return &"Idle"

		if actor.vel.x == 0:
			return &"Idle"

	return &""
