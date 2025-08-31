class_name LineEditor
extends Line2D
## Base class used for simple user generated line creation and editing.
## Inherited by classes such as [TrackEditor] and [PolygonEditor] for intuitive UIX.

@export var button_widget: PackedScene

## Where the cursor was located on its last left click.
var last_click_pos := -Vector2.INF

## Whether or not the cursor is currently hovering over a button widget.
var hovering_over_button: bool = false

var drawn_once: bool = false

### This Line2D converted to different polygons.
#var polyline: Array[PackedVector2Array]

var poly_buttons: Array[DraggableButton]
var button_positions: PackedVector2Array
var currently_dragging: DraggableButton


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed(&"quick_restart"):
		get_tree().reload_current_scene()
		return

	# Line edit when making or moving points around.
	if is_instance_valid(currently_dragging) or Input.is_action_just_pressed(&"e_select") or Input.is_action_just_released(&"e_select"):
		_line_editing()


## The process of designing the line and its draggable points.
func _line_editing():
	# Creating the buttons.
	if Input.is_action_just_pressed(&"e_select") and not hovering_over_button:
		last_click_pos = get_local_mouse_position()

		#Geometry2D.get_closest_point_to_segment()

		_create_button(last_click_pos, !drawn_once)

	# Updating points of the Line2D.
	_sync_p2b()

	## Creating the polyline.
	#if points.size() >= 2:
		#polyline = Geometry2D.offset_polyline(points, width / 2)

	# Dragging around a button.
	#if is_instance_valid(currently_dragging):
		#if _check_not_intersecting(button_positions, currently_dragging.position):
			#print("dont do thaat :( :( :( :( :( :( :( :(")
			#currently_dragging.position = Geometry2D.get_closest_points_between_segments()


#func _get_line_segments():
	#var segments: Array = []
#
	## Minus 1 to avoid an out-of-bounds error.
	#for point in range(points.size() - 1):
		#var segment: PackedVector2Array = [points[point], points[point + 1]]
		#segments.append(segment)
#
	#return segments


## Updates the [member points] to correspond with the positions of the [DraggableButton]s
func _sync_p2b():
	button_positions = poly_buttons.map(func(button: DraggableButton) -> Vector2: return button.position)
	points = button_positions

## Force rewrites the polygon when a point is removed.[br][br]
## [param to_be_removed] is a reference to the point that's being removed.
func _remove_point_on_poly(to_be_removed: DraggableButton):
	if to_be_removed.has_meta(&"first"):
		# Reset drawn_once if the only existing point was deleted,
		# otherwise make the next point the first point.
		if points.size() == 1:
			drawn_once = false
		else:
			poly_buttons[1].costume = "Red"
			poly_buttons[1].set_meta(&"first", true)

	poly_buttons.erase(to_be_removed)
	to_be_removed.queue_free()

	_sync_p2b()


## Check if the polygon you're trying to create doesn't intersect with itself.
func _check_not_intersecting(poly: PackedVector2Array, new_pos: Vector2) -> bool:
	var size: int = poly.size()

	if size <= 2:
		return true

	# Last point of the polygon
	var edge_start: Vector2 = poly[size - 1]

	for i in range(size - 2):
		if Geometry2D.segment_intersects_segment(poly[i], poly[i + 1], edge_start, new_pos) != null:
			push_warning("Cannot create a polygon that intersects with itself.")
			return false

	return true


func _create_button(at: Vector2, is_first: bool):
	var button_node: DraggableButton = button_widget.instantiate()
	# Node's child is the TextureButton.
	var button_real: TextureButton = button_node.get_child(0)

	button_node.position = at

	button_node.delete_attempted.connect(_remove_point_on_poly.bind(button_node))
	button_node.selected.connect(func(button: DraggableButton): currently_dragging = button)
	button_node.deselected.connect(func(_button: DraggableButton): currently_dragging = null)

	button_real.mouse_entered.connect(_update_hovering_over_button.bind(true))
	button_real.mouse_exited.connect(_update_hovering_over_button.bind(false))

	if is_first:
		button_node.costume = "Red"
		button_node.set_meta(&"first", true)
		drawn_once = true
		#button_real.pressed.connect(_close_outline)

	poly_buttons.append(button_node)
	add_child(button_node)


func _update_hovering_over_button(value: bool):
	hovering_over_button = value


func _close_outline():
	if not points.size() >= 3:
		return

	default_color = Color.hex(0xfcc64aff)
	closed = true


#func _create_polygon():
	#var body := StaticBody2D.new()
	#get_parent().call_deferred("add_child", body)
#
	#var collision := CollisionPolygon2D.new()
	#var visual := Polygon2D.new()
#
	#collision.polygon = points
	#visual.polygon = points
#
	#collision.position = position
	#visual.position = position
#
	#body.add_child(collision)
	#body.add_child(visual)
