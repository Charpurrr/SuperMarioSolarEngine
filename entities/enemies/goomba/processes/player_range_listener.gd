extends StateProcess

func _on_player_detect_area_entered(area: Area2D) -> void:
	if area.owner is Player and area.is_in_group(&"player_hitbox") and owner:
		owner.target = area.owner

func _on_player_detect_area_exited(area: Area2D) -> void:
	if area.owner is Player and area.is_in_group(&"player_hitbox") and owner:
		owner.target = null
