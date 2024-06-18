class_name Terrain
extends Polygon2D
## Vectorised interactable terrain.

@export var terrain_type: StringName = &"Solid"


func _ready():
	var body := StaticBody2D.new()
	var poly := CollisionPolygon2D.new()

	poly.polygon = polygon
	poly.position = position + offset

	call_deferred("add_child", body)
	body.call_deferred("add_child", poly)
