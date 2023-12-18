extends Label


@export var player: Player


func _physics_process(_delta):
	text = ("velocity.x = %.3f \n 
	slideable = %s \n 
	floor_angle = %.3f" %[
		player.vel.x, 
		player.movement.is_slide_slope(),
		player.get_floor_angle()
	])
