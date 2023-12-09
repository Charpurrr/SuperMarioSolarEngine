class_name WalkAVFX
extends PAVEffect
## Walking + running animation.


func do_effect():
	target.speed_scale = player.vel.x / movement.max_speed * 2

	if abs(player.vel.x) > movement.max_speed:
		target.play("run")
	else:
		target.play("walk")


func deactivate():
	super()

	target.speed_scale = 1
