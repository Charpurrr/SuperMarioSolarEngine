extends Control

@export var selector: OptionButton
@export var speaker_label: Label


func _ready():
	await selector.ready

	var saved_device: String = LocalSettings.load_setting("Audio", "device", "")

	_update_speaker_label()
	_update_list()

	AudioServer.output_device = saved_device

	for device in AudioServer.get_output_device_list():
		if saved_device == device:
			selector.selected = selector.get_item_index(hash(device))


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
	if selector.item_count != 0:
		selector.clear()

	for device in AudioServer.get_output_device_list():
		selector.add_item(device, hash(device))


func _on_item_selected(index):
	var device_name: String = selector.get_item_text(index)

	_update_speaker_label()

	AudioServer.output_device = device_name

	LocalSettings.change_setting(
		"Audio Device",
		"device",
		device_name
	)


func _on_refresh_pressed():
	_update_list()
