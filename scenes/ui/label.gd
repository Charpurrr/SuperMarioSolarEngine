extends Label


@export var player: Player


func _physics_process(_delta):
	text = ("velocity.x = %.3f \n 
	velocity.y = %.3f \n 
	state = %s \n
	SCL = %s" %[
		player.vel.x, 
		player.vel.y,
		player.state_manager.get_leaf(),
		player.crouchlock.crouchlock_enabled
	])
