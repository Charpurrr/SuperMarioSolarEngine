class_name ButtSlide
extends PlayerState
## Crouching while on a slope (or being forced.)


## Minimum sliding speed.
@export var min_speed: float = 10

## Friction applied when sliding along flat or shallow ground.
@export var friction: float = 0.125

## Maximum acceleration from sliding, when a slope is as steep as possible.
@export var max_accel: float = 0.22

## How much speed is conserved when changing slope angle.
## Higher numbers mean more speed is conserved.
@export var turn_forgiveness: float = 2.0

## Higher shallowness penalty means shallow slopes will have less effect on speed.
@export var shallowness_penalty: float = 0.5
## Higher slipperiness means more speed conservation on steep slopes.
@export var steep_slope_slipperiness: float = 10

## Speed at which the player slides.
var slide_speed: float = 0.0

## Stored previous direction, for changing slope angle.
var old_direction: Vector2

## True when the player does not have a slide direction yet.
var no_direction: bool


func _on_enter(handover_speed):
	actor.set_floor_snap_length(16.0)

	if handover_speed is float:
		old_direction = Vector2.DOWN
		slide_speed = handover_speed
	else:
		no_direction = true
		slide_speed = 0


func _physics_tick():
	if actor.is_on_floor():
		# The normal of the floor below
		var floor_normal: Vector2 = actor.get_floor_normal()
		
		# How flat the floor is, 0-1
		var flatness: float = floor_normal.dot(Vector2.UP)
		# How steep the floor is (opposite of flatness, just for convenience)
		var steepness: float = 1 - flatness
		
		# The direction the player is sliding in
		var slide_direction: Vector2

		# Set the slide direction to be downwards along the slope
		if floor_normal == Vector2.UP:
			# On flat ground, just go right.
			slide_direction = Vector2.RIGHT
		else:
			slide_direction = floor_normal.orthogonal()

			if slide_direction.dot(Vector2.DOWN) < 0:
				slide_direction = -slide_direction

		if no_direction:
			# If we have only just started sliding,
			# we need to convert the player's velocity into sliding speed.
			if floor_normal == Vector2.UP:
				slide_speed = actor.vel.x
			else:
				if abs(actor.vel.x) > abs(actor.vel.dot(slide_direction)):
					slide_speed = actor.vel.x * sign(floor_normal.x)
				else:
					slide_speed = actor.vel.dot(slide_direction)

			no_direction = false
		else:
			# If we're changing direction, redirect current sliding speed into the new direction
			if not slide_direction.is_equal_approx(old_direction):
				redirect_slide(slide_direction, old_direction)

		# Calculate acceleration and maximum speed based on steepness
		var slide_accel: float = pow(steepness, shallowness_penalty) * max_accel
		var target_speed: float = pow(steepness, shallowness_penalty) * min_speed

		# Accelerate down the slope
		accelerate(slide_accel, target_speed)
		
		# Decelerate due to friction
		decelerate(pow(flatness, steep_slope_slipperiness) * friction, target_speed)
		
		# Set the velocity
		actor.vel = slide_direction * slide_speed
		actor.vel.y += 0.1

		# Store the sliding direction so we can check for changes
		old_direction = slide_direction
	else:
		no_direction = true
		slide_speed = 0

		movement.apply_gravity()


func redirect_slide(new: Vector2, old: Vector2):
	# Calculate how similar the new direction is to the old direction
	var preserved = new.dot(old)

	# Store the sign: -1 if we have moved from an upward slope to a downward slope
	# or vice versa
	var new_sign = sign(preserved)
	
	# Take absolute value so we can work with 0 to 1 instead of -1 to 1
	preserved = abs(preserved)

	# Calculate how much speed would be lost
	var lost = 1 - preserved

	# Apply forgiveness to what was lost
	var lost_forgiven = pow(lost, turn_forgiveness)

	# Subtract the reduced loss from 1
	var final_preserved = 1 - lost_forgiven

	# Apply the new speed
	slide_speed *= final_preserved * new_sign


func accelerate(amount: Variant, speed_cap: float):
	if slide_speed + amount < speed_cap:
		slide_speed += amount
	elif slide_speed < speed_cap:
		slide_speed = speed_cap


func decelerate(amount: float, target: float):
	var direction = sign(slide_speed)
	var abs_speed = abs(slide_speed)

	if abs_speed > target:
		abs_speed = max(abs_speed - amount, target)

	slide_speed = abs_speed * direction


func _trans_rules():
	if not movement.is_slide_slope() and abs(actor.vel.x) < 0.5:
		return [&"Crouch", [true, false]]

	if not Input.is_action_pressed(&"down"):
		if old_direction.y == 0 and InputManager.get_x_dir() != 0:
			return &"Idle"
		if InputManager.get_x_dir() == -sign(old_direction.x):
			return &"Walk"

	if actor.is_on_floor() and input.buffered_input(&"jump"):
		return &"ButtSlideJump"

	return &""
