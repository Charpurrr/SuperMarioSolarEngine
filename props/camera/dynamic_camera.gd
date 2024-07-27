class_name DynamicCamera # Lakitu
extends Camera2D
## the word 'shift' refers to camera movement.
## Alternatively the word look can be used.

@export var actor: Player

var default_offset: Vector2 
## For resetting camera back to default offsets.
## Accounts for manually adjusted camera positions in editor.

# variables could use better names
@export var max_x_shift: int = 50
@export var max_y_shift: int = 15
@export var x_shift_speed: float = 0.07
@export var x_reset_speed: float = 0.01
@export var y_shift_speed: float = 0.2
@export var y_reset_speed: float = 0.8

@export var shift_trigger: float = 4 ## actor velocity threshold which triggers cam shifting.

@export var hold_duration: int = 30 ## Duration for holding down 'up'/'down' until cam shift is triggered
var hold_time: int = 0

func _ready(): 
	default_offset = offset 
	max_y_shift -= default_offset.y


func _process(delta):
	shift_x()
	shift_y()
	return


func shift_x():
	if abs(actor.vel.x) > shift_trigger:
		if actor.movement.facing_direction == 1:
			offset.x = lerpf(offset.x, max_x_shift, x_shift_speed)
		elif actor.movement.facing_direction == -1:
			offset.x = lerpf(offset.x, -max_x_shift, x_shift_speed)
	
	# walking in the opposite direction causes the camera to slowly shift back
	elif abs(actor.vel.x) < shift_trigger and sign(actor.movement.facing_direction) != sign(offset.x):
		offset.x = lerpf(offset.x, default_offset.x, x_reset_speed)


func shift_y(): # currntly works but needs to be rewritten.
	if Input.is_action_pressed("up"): # and actor.vel == Vector2.ZERO: <- is this needed?
		offset.y  = lerpf(offset.y, -max_y_shift, y_shift_speed)
	#elif Input.is_action_pressed("down") and actor.vel == Vector2.ZERO: # requires frame counting or should be removed entirely
		#offset.y  = lerpf(offset.y, max_y_shift, y_shift_speed) # this line needs tweaking
	else:
		offset.y = lerpf(offset.y, default_offset.y, y_reset_speed)


func is_default_offset() -> bool: ## to check if the camera is at its default offset
	return offset == default_offset


func y_shiftable(): # Is there a better way to use a counter in this situation?
	if hold_time < hold_duration:
		hold_time += 1
		return false
	else:
		hold_time = 0
		return true
	
		
