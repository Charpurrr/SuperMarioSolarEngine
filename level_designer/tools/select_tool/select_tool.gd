class_name SelectTool
extends Tool
## Default all-purpose selection tool.


@onready var selection_box: NinePatchRect = toolbar.editor.selection_box
@onready var selection_area: Area2D = selection_box.area
@onready var selection_shape: CollisionShape2D = selection_box.shape

var started_selection: bool

var point_start: Vector2
var point_end: Vector2


func _tick():
	_set_point_end()

	var point_top_l := Vector2(min(point_start.x, point_end.x), min(point_start.y, point_end.y))
	var point_bot_r := Vector2(max(point_start.x, point_end.x), max(point_start.y, point_end.y))

	var center_size: Vector2 = point_bot_r - point_top_l

	var left: float = selection_box.patch_margin_left
	var right: float = selection_box.patch_margin_right
	var top: float = selection_box.patch_margin_top
	var bottom: float = selection_box.patch_margin_bottom

	selection_box.size = center_size + Vector2(left + right, top + bottom)
	selection_box.position = point_top_l - Vector2(left, right)
	selection_box.visible = started_selection

	selection_shape.position = center_size / 2 + Vector2(left, right)
	selection_shape.shape.size = center_size

	if Input.is_action_just_released(&"left_mouse"):
		started_selection = false


func _unhandled_input(_event):
	_set_point_start()


func _set_point_start():
	if Input.is_action_just_pressed(&"left_mouse") and not started_selection:
		point_start = selection_box.get_global_mouse_position()
		started_selection = true


func _set_point_end():
	if started_selection:
		point_end = selection_box.get_global_mouse_position()
