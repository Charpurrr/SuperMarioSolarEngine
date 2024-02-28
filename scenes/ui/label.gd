extends Label


func _physics_process(_delta):
	text = (
	"fps = %s \n
	velocity.x = %.3f
	velocity.y = %.3f \n
	state = %s
	SCL = %s" %[
		Engine.get_frames_per_second(),
		get_parent().player.vel.x, 
		get_parent().player.vel.y,
		get_parent().player.state_manager.get_leaf(),
		get_parent().player.crouchlock.crouchlock_enabled
	])
