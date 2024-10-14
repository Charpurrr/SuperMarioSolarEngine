class_name PreviewItem
extends Node2D
## An item placed inside of the level designer.

@export var selection_shape: CollisionShape2D

var is_grabbed: bool = false
var item_data: EditorItem
var display: Node2D
var property_values: Dictionary = {}
var property_displays: Dictionary = {}


func _ready():
	var shape = item_data.preview_display_data.get_selection_shape()
	if shape != null:
		selection_shape.shape = shape


func create(data: EditorItem):
	item_data = data
	display = data.preview_display_data.create()
	add_child(display)
	for property in data.properties:
		var prop_name = property.name
		var prop_display_data = property.display_data

		var prop_display = prop_display_data.add_to(display)
		prop_display.preview_display = display
		prop_display.preview_item = self
		property_displays[prop_name] = prop_display

		# TODO: Find a better way of exporting variant types.
		# https://github.com/godotengine/godot/pull/89324?
		set_property(property.default[0], prop_name)


func set_property(value: Variant, prop_name: StringName) -> void:
	property_values[prop_name] = value
	property_displays[prop_name].set_value(value)


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
