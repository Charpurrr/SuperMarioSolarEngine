extends OptionButton

@export var options: ControlsContents


func _ready():
	Input.joy_connection_changed.connect(_update_list)


func _update_list(device_port: int, connected: bool):
	var joypad_name: String = Input.get_joy_name(device_port)

	print(device_port, joypad_name)

	if connected:
		add_item(joypad_name, device_port)
	else:
		remove_item(get_item_index(device_port))


func _on_item_selected(index):
	options.device_port = index
	options.update_buttons()
