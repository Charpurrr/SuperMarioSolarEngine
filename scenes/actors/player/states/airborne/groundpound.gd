class_name GroundPound
extends PlayerState
## Pressing down while airborne.


## How much the groundpound offsets you on the Y axis.
@export var gp_offset: float = -5


func _on_enter(_handover):
	movement.consume_coyote_timer()

	actor.vel.y = 0
	actor.vel.x = 0

	actor.position.y += gp_offset


func _tell_switch():
	if Input.is_action_just_pressed(&"dive"):
		return &"AirborneDive"

	if not actor.doll.is_playing():
		return &"GroundPoundFall"

	return &""
