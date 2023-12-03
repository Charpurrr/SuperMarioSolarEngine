class_name DiveAVFX
extends PAVEffect
## The dive rotation.


func do_effect():
	target.play("dive")
	target.rotation = lerp_angle(target.rotation, movement.body_rotation, 0.5)
