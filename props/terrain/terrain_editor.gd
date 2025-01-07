extends Line2D

@export var button_widget: PackedScene

## Current cursor position.
var cursor_pos: Vector2
## Where the cursor was located on its last left click.
var last_click_pos := -Vector2.INF

## Whether or not the cursor is currently hovering over a button widget.
var hovering_over_button: bool = false

var drawn_once: bool = false


func _process(_delta: float) -> void:
	if not closed:
		_line_edit_mode()
		return

	if Input.is_action_just_pressed("end_polygon_creation"):
		var body := Polygon2D.new()

		body.polygon = points
		body.position = position

		get_parent().call_deferred("add_child", body)


## Logic for creating the outline of a platform or terrain.
func _line_edit_mode():
	cursor_pos = get_local_mouse_position()

	if _is_viable_creation():
		var pos: Vector2

		last_click_pos = cursor_pos

		if not drawn_once:
			position = last_click_pos
			pos = Vector2.ZERO
			drawn_once = true
			_create_button(pos, true)
		else:
			pos = last_click_pos
			_create_button(pos, false)

		# Jank Godot fix.
		var poly = points
		poly.append(pos)
		points = poly


## Return if a point creation input is possible or not.
func _is_viable_creation() -> bool:
	if closed:
		return false

	if hovering_over_button:
		return false

	if not Input.is_action_just_pressed(&"select"):
		return false

	if not _check_not_intersect(points, cursor_pos):
		return false

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


func _create_button(at: Vector2, is_first: bool):
		var button_node: Node2D = button_widget.instantiate()
		var button_real: TextureButton = button_node.get_child(0)
		add_child(button_node)
		button_node.position = at

		button_real.mouse_entered.connect(_update_hovering_over_button.bind(true))
		button_real.mouse_exited.connect(_update_hovering_over_button.bind(false))

		if is_first:
			button_node.costume = "Red"
			# Node's child is the TextureButton.
			button_real.pressed.connect(_end_creation)


func _update_hovering_over_button(value: bool):
	hovering_over_button = value


func _end_creation():
	if not points.size() >= 3:
		return

	modulate = Color.AQUAMARINE
	closed = true
