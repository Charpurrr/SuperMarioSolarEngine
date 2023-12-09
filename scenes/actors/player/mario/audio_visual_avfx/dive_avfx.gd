class_name DiveAVFX
extends PAVEffect
## The dive rotation.


func do_effect():
	target.play("dive")
	target.rotation = lerp_angle(target.rotation, movement.body_rotation * movement.facing_direction, 0.5)


func deactivate():
	super()

	target.rotation = 0
