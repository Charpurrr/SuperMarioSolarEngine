extends Line2D

## Current cursor position.
var cursor_pos: Vector2
## Where the cursor was located on its last left click.
var last_click_pos := -Vector2.INF

var drawn_once: bool = false


func _physics_process(_delta):
	if not closed:
		_line_edit_mode()
		return
	else:
		if Input.is_action_just_pressed("end_polygon_creation"):
			var body := Polygon2D.new()

			body.polygon = points
			body.position = position

			get_parent().call_deferred("add_child", body)


func _draw():
	_draw_point()


## Placing a points point.
func _draw_point():
	for point in points:
		draw_circle(point, 3, Color(1.0, 1.0, 1.0, 0.5))


## Logic for creating the outline of a platform or terrain.
func _line_edit_mode():
	cursor_pos = get_local_mouse_position()

	if _is_viable_creation():
		var pos: Vector2

		last_click_pos = cursor_pos

		if drawn_once:
			pos = last_click_pos
		else:
			pos = Vector2.ZERO
			drawn_once = true

		# Jank godot fix.
		var poly = points
		poly.append(pos)
		points = poly

		queue_redraw()


## Return if a point creation input is possible or not.
func _is_viable_creation() -> bool:
	if closed:
		return false

	if not Input.is_action_just_pressed("left_mouse"):
		return false

	if not _check_not_intersect(points, cursor_pos):
		return false

	if not drawn_once:
		$Button.visible = true
		position = cursor_pos

	return last_click_pos != cursor_pos


## Check if the polygon you're trying to create doesn't intersect with itself.
func _check_not_intersect(poly: PackedVector2Array, new_pos: Vector2) -> bool:
	var size: int = poly.size()

	if size <= 2:
		return true

	var edge_start: Vector2 = poly[size - 1]

	for i in size - 2:
		if Geometry2D.segment_intersects_segment(poly[i], poly[i + 1], edge_start, new_pos):
			push_warning("Cannot create a polygon that intersects with itself.")
			return false

	return true


func _on_button_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("left_mouse") and _check_not_intersect(points, Vector2.ZERO):
		modulate = Color.AQUAMARINE
		closed = true
