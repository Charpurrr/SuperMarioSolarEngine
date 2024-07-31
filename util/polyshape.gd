extends CollisionPolygon2D


func _ready():
	var parent_poly: Polygon2D = get_parent().get_parent()

	parent_poly.polygon = polygon
