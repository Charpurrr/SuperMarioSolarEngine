extends UISelector

signal audio_output_list_changed()

@export var speaker_label: Label

var audio_device_list: PackedStringArray


func _ready() -> void:
	super()

	LocalSettings.setting_changed.connect(_setting_updated)
	item_selected.connect(_on_item_selected)

	audio_output_list_changed.connect(_update_list)
	audio_device_list = AudioServer.get_output_device_list()

	_update_speaker_label()
	_update_list()

	var saved_device: String = LocalSettings.load_setting("Audio", "device", "Default")
	AudioServer.output_device = saved_device

	for device in audio_device_list:
		if saved_device == device:
			selected = get_item_index(audio_device_list.find(device))


func _process(_delta: float) -> void:
	var new_device_list: PackedStringArray = AudioServer.get_output_device_list()

	if new_device_list != audio_device_list:
		var selected_device: String = get_item_text(selected)

		# If the selected audio device is removed, reset it to "Default"
		if not selected_device in new_device_list:
			push_warning("Selected device removed. Resetting to Default.")
			AudioServer.output_device = "Default"
			selected = 0

		audio_device_list = new_device_list
		audio_output_list_changed.emit()


func _update_speaker_label():
	var speaker_mode_text: String
	var speaker_mode = AudioServer.get_speaker_mode()

	match speaker_mode:
		AudioServer.SPEAKER_MODE_STEREO:
			speaker_mode_text = "Stereo"
		AudioServer.SPEAKER_SURROUND_31:
			speaker_mode_text = "Surround 3.1"
		AudioServer.SPEAKER_SURROUND_51:
			speaker_mode_text = "Surround 5.1"
		AudioServer.SPEAKER_SURROUND_71:
			speaker_mode_text = "Surround 7.1"

	speaker_label.text = "Speaker Mode: %s" % speaker_mode_text


func _update_list():
	var current_items: Dictionary[String, int] = {}
	for item_number in range(item_count):
		current_items[get_item_text(item_number)] = item_number

	for device in audio_device_list:
		if device not in current_items:
			add_item(device)

	for item in current_items.keys():
		if item not in audio_device_list:
			remove_item(current_items[item])


func _on_item_selected(index):
	var device_name: String = audio_device_list[index]

	_update_speaker_label()

	AudioServer.output_device = device_name

	LocalSettings.change_setting("Audio", "device", device_name)


func _setting_updated(key: String, new_value: Variant = null):
	if key != "device": return

	selected = get_item_index(audio_device_list.find(new_value))
