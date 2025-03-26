extends Node
## Settings stored on the user's system.

signal setting_changed(key, new_value)

const FILE_PATH: String = "user://settings.cfg"
var config := ConfigFile.new()

# Dictionary of every key and its default value.
var defaults: Dictionary[String, Variant] = {}


func _init():
	if not FileAccess.file_exists(FILE_PATH):
		config.save(FILE_PATH)

	var err = config.load(FILE_PATH)

	if err != OK:
		push_error("Error loading config file!")


func load_setting(section: String, key: String, default: Variant) -> Variant:
	if not defaults.has(key):
		defaults[key] = default

	return config.get_value(section, key, default)


func change_setting(section: String, key: String, value: Variant):
	config.set_value(section, key, value)
	config.save(FILE_PATH)

	emit_signal(&"setting_changed", key, value)


func reset_settings() -> void:
	# This logic only works if reset_settings() is never ran
	# before every possible option has ran a load_setting() at least once.
	# (I.e. by setting a default value on startup.)
	for section in config.get_sections():
		for key in config.get_section_keys(section):
			# Only reset if there's a default value to reset to.
			# See load_setting().
			if defaults.has(key):
				change_setting(section, key, defaults[key])
