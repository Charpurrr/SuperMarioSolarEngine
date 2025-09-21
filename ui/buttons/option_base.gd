@abstract
class_name OptionBase
extends UIButton

## The value that gets loaded in by default if there is no saved setting.?
@export var default_value: Variant

## Which section this button's value gets saved to in [LocalSettings].
@export var setting_section: String
## Which key this button's value gets saved to in [LocalSettings].
@export var setting_key: String

## Variant typed so extended classes can set their own type.
var value: Variant = false


func _ready():
	super()

	LocalSettings.connect(&"setting_changed", update_value)

	# Initialise buttons and settings
	var saved_val: Variant = LocalSettings.load_setting(
		setting_section, setting_key, default_value
	)
	update_value(setting_key, saved_val)
	GameState.setting_initialised.emit(setting_key, saved_val)


func update_value(key: String, new_value: Variant = null):
	# If the entered key doesn't relate to the button running this code
	if key != setting_key:
		return

	value = new_value

	_update_button()


func change_setting(new_value):
	if setting_section.is_empty() or setting_key.is_empty():
		return

	LocalSettings.change_setting(setting_section, setting_key, new_value)


## Overwritten by the parent class.[br]
## Defines how the option's text is displayed.
@abstract
func _update_button()
