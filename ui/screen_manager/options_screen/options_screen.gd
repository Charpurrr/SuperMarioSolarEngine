class_name OptionsScreen
extends Screen
## Submenu in the pause menu for setting various variables.[br][br]
## If you're looking for the actual option functionalities,
## consider looking in the GameState global.

@export var fps_cap_button: OptionEnum


func _ready() -> void:
	LocalSettings.setting_changed.connect(_setting_changed)

	# Disable the FPS cap button when V Sync is enabled at startup
	fps_cap_button.toggle_disable(LocalSettings.load_setting("General", "v_sync", 0))


func _setting_changed(key: String, _value: Variant) -> void:
	if key == "v_sync":
		fps_cap_button.toggle_disable()
