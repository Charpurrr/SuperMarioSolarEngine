extends Label

@onready var player: CharacterBody2D


func _physics_process(_delta):
	if is_instance_valid(get_parent().player):
		player = get_parent().player

	if player == null:
		return

	text = (
		"""FPS = %s \n
		is_on_floor() = %s
		can_air_action() = %s
		get_floor_angle / TAU = %.3f
		floor_incline = %.3f \n
		position.x = %.3f
		position.y = %.3f
		velocity.x = %.3f
		velocity.y = %.3f \n
		body_rotation = %.3f
		doll.rotation = %.3f
		facing = %d
		state = %s"""
		% [
			Engine.get_frames_per_second(),
			player.is_on_floor(),
			player.movement.can_air_action(),
			player.get_floor_angle() / TAU,
			player.movement.get_floor_incline(),
			player.global_position.x,
			player.global_position.y,
			player.vel.x,
			player.vel.y,
			player.movement.body_rotation,
			player.doll.rotation,
			player.movement.facing_direction,
			player.state_manager.get_leaf(),
		]
	)
