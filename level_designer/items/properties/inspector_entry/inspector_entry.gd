class_name InspectorEntry
extends HBoxContainer

signal value_changed(value: Variant)

@export var label: Label


func set_label(text: String) -> void:
	label.text = text


func set_value(value: Variant) -> void:
	assert(false, "Missing set_value definition for %s." % name)


func _on_value_changed(value: Variant) -> void:
	value_changed.emit(value)
