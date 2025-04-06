class_name Hitbox extends Area2D

@export var damage_component : DamageComponent

var disabled: bool:
	set(_disabled):
		get_shape().set_deferred(&"disabled", _disabled)
		disabled = _disabled

func get_shape() -> CollisionShape2D:
	return get_child(0) # better handling later perchance

static func can_harm_enemies(area: Area2D):
	return area is Hitbox \
	&& area.is_in_group(&"enemy_harmable") \
	&& area.damage_component \
	&& !area.disabled

static func can_harm_player(area: Area2D):
	return area is Hitbox \
	&& area.is_in_group(&"player_harmable") \
	&& area.damage_component \
	&& !area.disabled
