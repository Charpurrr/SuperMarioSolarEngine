class_name OptionBool
extends OptionBase
## UI button that can be turned on or off.

@export var default_value: bool = false

const ON_TEXT: String = "ON"
const OFF_TEXT: String = "OFF"


func _pressed():
	change_setting(!value)


func _update_button():
	text = ON_TEXT if value else OFF_TEXT


func _get_default_value() -> bool:
	return default_value
