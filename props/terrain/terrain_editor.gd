extends Line2D

@export var button_widget: PackedScene
@export var snapper_path: Path2D
@export var snapper_follow: PathFollow2D
@export var add_point_gfx: Sprite2D

## Current cursor position.
var cursor_pos: Vector2
## Where the cursor was located on its last left click.
var last_click_pos := -Vector2.INF

## Whether or not the cursor is currently hovering over a button widget.
var hovering_over_button: bool = false

var drawn_once: bool = false

## This Line2D converted to different polygons.
var polyline: Array[PackedVector2Array]
var poly_buttons: Array[Node2D]


func _process(_delta: float) -> void:
	cursor_pos = get_local_mouse_position()

	#add_point_gfx.visible = true
	#add_point_gfx.position = Math.get_closest_point_line()

	#print(_get_line_segments())

	#for line in _get_line_segments():
		#var rect := ColorRect.new()
		#
		#rect.position = Math.get_closest_point_line(line[0], line[1], cursor_pos)

	if not closed:
		_line_edit_mode()
		return

	if Input.is_action_just_pressed("e_end_polygon_creation"):
		_create_polygon()


## Logic for creating the outline of a platform or terrain.
func _line_edit_mode():
	var button_positions: PackedVector2Array

	for button in poly_buttons:
		button_positions.append(button.position)

	points = button_positions

	# Creating the polyline. TODO: AAAAAAAAAAAAAAAAAHHH BADD BADDD!!!
	polyline = Geometry2D.offset_polyline(points, width / 2)

	for child in get_children():
		if child is CollisionPolygon2D:
			child.queue_free()

	for poly in polyline:
		var shape := CollisionPolygon2D.new()
		shape.polygon = poly
		add_child(shape)

	if not _can_line_edit():
		return

	var pos: Vector2

	last_click_pos = cursor_pos

	# Creating the buttons.
	if not drawn_once:
		position = last_click_pos
		pos = Vector2.ZERO
		drawn_once = true
		_create_button(pos, true)
	else:
		pos = last_click_pos
		_create_button(pos, false)


#func _get_line_segments():
	#var segments: Array = []
#
	## Minus 1 to avoid an out-of-bounds error.
	#for point in range(points.size() - 1):
		#var segment: PackedVector2Array = [points[point], points[point + 1]]
		#segments.append(segment)
#
	#return segments


## Force rewrites the polygon when a point is removed.[br][br]
## [code]to_be_removed[/code] is a reference to the point that's being removed.
func _remove_point_on_poly(to_be_removed: Node2D):
	if not points.size() >= 3:
		return

	poly_buttons.erase(to_be_removed)
	to_be_removed.queue_free()

	points = poly_buttons


## Return if a point creation input is possible or not.
func _can_line_edit() -> bool:
	return (
		not closed and
		not hovering_over_button and 
		Input.is_action_just_pressed(&"select") and 
		last_click_pos != cursor_pos and
		_check_not_intersect(points, cursor_pos)
	)


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


func _create_button(at: Vector2, is_first: bool):
	var button_node: Node2D = button_widget.instantiate()
	var button_real: TextureButton = button_node.get_child(0)

	add_child(button_node)
	button_node.position = at

	button_node.delete_attempted.connect(_remove_point_on_poly.bind(button_node))

	button_real.mouse_entered.connect(_update_hovering_over_button.bind(true))
	button_real.mouse_exited.connect(_update_hovering_over_button.bind(false))

	if is_first:
		button_node.costume = "Red"
		# Node's child is the TextureButton.
		button_real.pressed.connect(_close_outline)

	poly_buttons.append(button_node)


func _update_hovering_over_button(value: bool):
	hovering_over_button = value


func _close_outline():
	if not points.size() >= 3:
		return

	modulate = Color.AQUAMARINE
	closed = true


func _create_polygon():
	var body := StaticBody2D.new()
	get_parent().call_deferred("add_child", body)

	var poly := CollisionPolygon2D.new()
	var visual := Polygon2D.new()

	poly.polygon = points
	visual.polygon = points

	poly.position = position
	visual.position = position

	body.add_child(poly)
	body.add_child(visual)
