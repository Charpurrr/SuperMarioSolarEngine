@tool
class_name SelectionShapeGenerator
extends ResourceGenerator
## Generator and editor for selection shapes of editor items.


## Press to apply the edits made to the shape.
@export var apply_manual_edit: bool = false :
	set(val):
		_save_edits()
	get:
		return false

## An EditorItem resource can be dragged here to edit it.
@export var manual_edit_item: EditorItem = null :
	set(val):
		manual_edit_item = val
		_update_edit_preview()
	get:
		return manual_edit_item

## Reference to the PreviewItem used to preview the EditorItem.
var preview_display: Node2D = null

## The polygon that will be used to preview and edit selection shapes.
@onready var edit_polygon = $EditPolygon


## Saves edits to the selected item.
func _save_edits():
	var shape = ConvexPolygonShape2D.new()
	shape.points = edit_polygon.polygon
	manual_edit_item.preview_display_data.set_selection_shape(shape)
	_resave(manual_edit_item)


## Updates the edit preview to match the selected edit item.
func _update_edit_preview():
	if edit_polygon == null:
		await ready
	_clear_edit_preview()
	if manual_edit_item == null:
		return

	var display_data = manual_edit_item.preview_display_data
	var shape = display_data.get_selection_shape()
	if shape == null:
		return

	edit_polygon.polygon = display_data.get_selection_shape().points
	var inst = manual_edit_item.preview_display_data.create()
	preview_display = inst
	add_child(inst)


## Clears the edit preview.
func _clear_edit_preview():
	edit_polygon.polygon = []
	if preview_display != null:
		preview_display.queue_free()
		preview_display = null


func _is_correct_type(resource):
	return resource is EditorItem


func _process_all(filesystem, resource_list):
	var paths = PackedStringArray()
	for item in resource_list:
		item = item as EditorItem
		var display_data = item.preview_display_data as PreviewDisplayData
		if display_data == null:
			continue

		if not display_data.needs_static_selection_shape():
			continue

		var shape = display_data.get_selection_shape()
		if shape != null:
			continue

		var texture: Texture2D = display_data.get_reference_texture()
		if texture == null:
			continue

		var new_shape = _shape_from_texture(texture)
		display_data.set_selection_shape(new_shape)

		_resave(item)
		paths.append(item.resource_path)

	filesystem.reimport_files(paths)

	_update_edit_preview()


func _shape_from_texture(texture):
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(texture.get_image())

	var bitmap_size = bitmap.get_size()
	var polygons = bitmap.opaque_to_polygons(Rect2(Vector2.ZERO, bitmap_size))

	var connected_polygon = PackedVector2Array()
	for polygon in polygons:
		connected_polygon.append_array(polygon)

	var center_offset: Vector2 = bitmap_size / 2

	for i in connected_polygon.size():
		connected_polygon.set(i, connected_polygon[i] - center_offset)

	var final_shape = ConvexPolygonShape2D.new()
	final_shape.set_point_cloud(connected_polygon)
	return final_shape
