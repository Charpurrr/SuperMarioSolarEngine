class_name PreviewItem
extends Node2D
## An item placed inside of the level designer.

var is_grabbed: bool = false
var item_data: EditorItem
var display: Node2D

@onready var selection_shape: CollisionShape2D = %SelectionShape

func _ready():
	var shape = item_data.preview_display_data.get_selection_shape()
	if shape != null:
		selection_shape.shape = shape


func create(data: EditorItem):
	item_data = data
	display = data.preview_display_data.create()
	add_child(display)


func grab() -> void:
	is_grabbed = true
	modulate.a = 0.5


func drop() -> void:
	is_grabbed = false
	modulate.a = 1


func select() -> void:
	modulate.r = 0.5
	modulate.g = 0.5


func deselect() -> void:
	modulate.r = 1
	modulate.g = 1
