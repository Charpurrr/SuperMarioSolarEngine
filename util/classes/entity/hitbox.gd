class_name Hitbox extends Area2D

@export var damage_component: DamageComponent

@export var disabled: bool:
	set(_disabled):
		for child in get_children():
			child.disabled = _disabled
		disabled = _disabled

signal damage_collision(damage: DamageComponent, sender: Area2D)

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D):
	if area is Hitbox \
	and area.damage_component \
	and !area.disabled \
	and area.owner != self.owner:
		damage_collision.emit(area.damage_component, area)
