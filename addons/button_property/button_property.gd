class_name ButtonProperty
extends EditorInspectorPlugin


func _can_handle(object):
	return object is ResourceGenerator or object is SelectionShapeGenerator


func _parse_property(object, _type, name, _hint_type, hint_string, _usage_flags, _wide):
	if hint_string.begins_with("Button"):
		var button := Button.new()

		button.text = hint_string.substr(7).replace("_", " ")

		button.connect("pressed", object.set.bind(name, "pressed"))

		add_custom_control(button)

		return true
	return false
