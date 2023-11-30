class_name GroundPoundLand
extends PlayerState
## Landing after a groundpound.


## If the player can simply cancel out of the groundpound landing.
@export var can_ignore: bool = true


func _on_enter(_handover):
	actor.vel.x = 0


func _tell_switch():
	if input.buffered_input(&"jump"):
		return &"GroundPoundJump"

	if Input.is_action_just_pressed(&"spin"):
		return &"GroundedSpin"

	if can_ignore and input_direction != 0:
		return &"Idle"
	elif not av.fallback_sprite.is_playing():
		return &"Idle"

	return &""
