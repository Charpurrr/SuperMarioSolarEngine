extends Node
## Settings stored on the system.


const FILE_PATH: String = "user://settings.cfg"
var config := ConfigFile.new()


func _init():
	if not FileAccess.file_exists(FILE_PATH):
		config.save(FILE_PATH)


func load_setting(section: String , key: String, default: Variant):
	var err = config.load(FILE_PATH)

	if err == OK:
		return config.get_value(section, key, default)
	else:
		push_error("Error loading config file!")

		return null


func change_setting(section: String , key: String, value: Variant):
	config.set_value(section, key, value)

	config.save(FILE_PATH)
