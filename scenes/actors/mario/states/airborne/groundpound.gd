class_name GroundPound
extends PlayerState
## Pressing down while airborne.


## How much the groundpound offsets you on the y axis
const GP_OFFSET_Y: float = -5


func _on_enter(_handover):
	movement.consume_coyote_timer()

	actor.vel.y = 0
	actor.vel.x = 0

	actor.position.y += GP_OFFSET_Y


func _tell_switch():
	if not av.fallback_sprite.is_playing():
		return &"GroundPoundFall"

	return &""
