extends OptionButton

@export var options: ControlsContents


func _ready():
	Input.joy_connection_changed.connect(_update_list)


func _update_list(device_port: int, connected: bool):
	var joypad_name: String = Input.get_joy_name(device_port)
	var saved_controller: String = LocalSettings.load_setting(
		"Controller (Player: %d)" % options.player,
		"name",
		""
	)

	if connected:
		add_item(joypad_name, device_port)
	else:
		remove_item(get_item_index(device_port))

	for id in Input.get_connected_joypads():
		if saved_controller == Input.get_joy_name(id):
			selected = id


func _on_item_selected(index):
	var joypad_name: String = Input.get_joy_name(index)

	LocalSettings.change_setting(
		"Controller (Player: %d)" % options.player,
		"name",
		joypad_name
	)

	options.device_port = index
	options.update_buttons()
