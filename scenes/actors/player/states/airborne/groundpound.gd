class_name GroundPound
extends PlayerState
## Pressing down while airborne.


## How much the groundpound offsets you on the Y axis.
@export var gp_offset: float = -5


func _on_enter(_handover):
	actor.hitbox.disabled = false
	actor.small_hitbox.disabled = true
	actor.dive_hitbox.disabled = true

	movement.consume_coyote_timer()
	movement.body_rotation = 0

	actor.vel.y = 0
	actor.vel.x = 0

	actor.doll.rotation = 0
	actor.position.y += gp_offset


func _tell_switch():
	if Input.is_action_just_pressed(&"dive"):
		return &"OdysseyDive"

	if not actor.doll.is_playing():
		return &"GroundPoundFall"

	return &""
