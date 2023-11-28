class_name GroundPound
extends PlayerState
## Pressing down while airborne.


## How much the groundpound offsets you on the y axis
const GP_OFFSET_Y: float = -5

## Check if the ground pound animation has finished
var anim_finished: bool = false


func _on_enter(_handover):
	movement.consume_coyote_timer()

	actor.position.y += GP_OFFSET_Y
	actor.vel.y = 0
	actor.vel.x = 0

	actor.animplay.play("ground_pound")


func _on_exit():
	anim_finished = false
	actor.animplay.stop()


func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		"ground_pound":
			anim_finished = true


func _tell_switch():
	if anim_finished:
		return &"GroundPoundFall"

	return &""
