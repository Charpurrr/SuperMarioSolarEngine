extends Label


@export var player: Player


func _physics_process(_delta):
	text = "velocity.x = %.3f \n canws = %s" %[player.vel.x, player.movement.can_wallslide()]
