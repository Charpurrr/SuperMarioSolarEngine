class_name DynamicCamera # Lakitu
extends Camera2D
## the word 'shift' refers to camera movement.
## Alternatively the word look can be used.

@export var actor: Player

var default_offset: Vector2 
## For resetting camera back to default offsets.
## Accounts for manually adjusted camera positions in editor.
@export var max_x_shift: int = 50
@export var max_y_shift: int = 15
@export var x_shift_speed: float = 0.07
@export var y_shift_speed: float = 0.7

@export var shift_trigger: float = 4 ## actor velocity threshold theat triggers shifting.

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
		if actor.movement.facing_direction == 1:
			offset.x = lerpf(offset.x, max_x_shift, x_shift_speed)
		elif actor.movement.facing_direction == -1:
			offset.x = lerpf(offset.x, -max_x_shift, x_shift_speed)


func shift_y():
	if Input.is_action_pressed("up") and actor.vel == Vector2.ZERO:
		offset.y  = lerpf(offset.y, -max_y_shift, y_shift_speed)
	else:
		offset.y = default_offset.y	


func is_default_offset() -> bool: ## to check if the camera is at its default offset
	return offset == default_offset
