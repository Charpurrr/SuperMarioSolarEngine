extends Label


func _physics_process(_delta):
	text = (
	"fps = %s \n
	velocity.x = %.3f
	velocity.y = %.3f \n
	body_rotation = %.3f
	doll.rotation = %.3f
	facing = %d
	state = %s
	" %[
		Engine.get_frames_per_second(),
		get_parent().player.vel.x, 
		get_parent().player.vel.y,
		get_parent().player.movement.body_rotation,
		get_parent().player.doll.rotation,
		get_parent().player.movement.facing_direction,
		get_parent().player.state_manager.get_leaf(),
	])
