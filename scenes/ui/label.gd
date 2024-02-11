extends Label


@export var player: Player


func _physics_process(_delta):
	text = ("velocity.x = %.3f \n 
	velocity.y = %.3f \n 
	state = %s" %[
		player.vel.x, 
		player.vel.y,
		player.state_manager.get_leaf(),
	])
