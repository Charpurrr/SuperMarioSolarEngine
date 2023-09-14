class_name GroundPound
extends State
# Pressing down while airborne


const GP_OFFSET_Y : float = -5 # How much the groundpound offsets you on the y axis

var anim_finished : bool = false # Check if the ground pound animation has finished


func on_enter():
	actor.position.y += GP_OFFSET_Y
	actor.vel.y = 0
	actor.vel.x = 0

	actor.animplay.play("ground_pound")


func on_exit():
	anim_finished = false
	actor.animplay.stop()


func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		"ground_pound":
			anim_finished = true


func switch_check():
	if anim_finished:
		return get_states().groundpound_fall

