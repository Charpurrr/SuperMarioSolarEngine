class_name OptionBase
extends UIButton

@export var setting_section: String
@export var setting_key: String

## Variant typed so extended classes can set their own type.
var value: Variant = false


func _ready():
	super()

	value = _get_default_value()

	LocalSettings.connect(&"setting_changed", reload_value)
	reload_value(setting_key)


func reload_value(key: String, new_value: Variant = null):
	if key != setting_key: return

	value = new_value

	if value == null:
		value = LocalSettings.load_setting(setting_section, setting_key, _get_default_value())

	_update_value()


func change_setting(new_value):
	if setting_section.is_empty() or setting_key.is_empty():
		return

	LocalSettings.change_setting(setting_section, setting_key, new_value)


## Overwritten by the parent class.
func _update_value():
	pass


## Overwritten by the parent class.
func _get_default_value():
	return null
