extends State

func _physics_process(_delta: float) -> void:
	var player: Player = owner.target
	if player:
		owner.vel.x = -1.5 * sign(owner.global_position.x - player.global_position.x)
		owner.doll.flip_h = owner.global_position.x < player.global_position.x

func _on_exit():
	owner.vel = Vector2.ZERO
