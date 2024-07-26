class_name Lakitu
extends Camera2D
## the word 'shift' refers to camera movement.
## Alternatively the word look can be used.

@export var actor: Player

var default_offset: Vector2 
## For resetting camera back to default offsets.
## Accounts for manually adjusted camera positions.
@export var max_x_shift: int = 30
@export var max_y_shift: int = 15
@export var x_shift_speed: float = 0.07
@export var y_shift_speed: float = 0.7

@export var shift_trigger: float = 4 #
@export var look_up_frames: int = 30 ## How long the up key must be held before the camera begins to shift upwards 

func _ready():
	actor = get_parent() # completely unnecessary line 
	default_offset = offset 
	max_y_shift -= default_offset.y


func _process(delta):
	shift_x()
	shift_y()
	return


func shift_x():
	if abs(actor.vel.x) > shift_trigger:
		# you can't use input because if you're moving but not pressing dir it won't reg
		# you can't use facing in case you're backwards sliding. Just going to use it for now though
		if actor.movement.facing_direction == 1:
			#offset.x = default_offset.x + max_x_shift
			offset.x = accel_shift(offset.x, max_x_shift, x_shift_speed)
		elif actor.movement.facing_direction == -1:
			#offset.x = default_offset.x - max_x_shift
			offset.x = accel_shift(offset.x, -max_x_shift, x_shift_speed)


func shift_y():
	if Input.is_action_pressed("up"):
		#offset.y = default_offset.y - max_y_shift
		offset.y  = accel_shift(offset.y, -max_y_shift, y_shift_speed)
	else:
		offset.y = default_offset.y	


func accel_shift(current_offset, target_offset, shift_speed):
	var new_offset: int
	new_offset = lerpf(current_offset, target_offset, shift_speed)
	return new_offset


func look_up_counter():
	pass
