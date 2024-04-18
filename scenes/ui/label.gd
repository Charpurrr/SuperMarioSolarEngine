extends Label


#@onready var player: Player
#
#
#func _ready():
	#await get_parent().ready
	#player = get_parent().player


func _physics_process(_delta):
	text = (
	"fps = %s \n
	velocity.x = %.3f
	velocity.y = %.3f \n
	rotation = %.3f
	facing = %d
	state = %s
	" %[
		Engine.get_frames_per_second(),
		get_parent().player.vel.x, 
		get_parent().player.vel.y,
		get_parent().player.movement.body_rotation,
		get_parent().player.movement.facing_direction,
		get_parent().player.state_manager.get_leaf(),
	])
