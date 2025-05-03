extends StateProcess

func _on_damage(damage: DamageComponent, source: Hitbox) -> void:
	var player = source.owner
	if player is Player and damage.type == DamageComponent.DamageType.SQUISH:
		player.vel.y = -3
