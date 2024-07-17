class_name BindButtonKey
extends BindButton
## A bind button catered towards keyboard inputs.
## Lots of functions in this script are defined by its parent class.
## See [BindButton] for descriptions and types.


func _ready():
	input_device_name = &"Keyboard"

	response_timer = $KeyTimer
	clear_button = %ClearKey
	reset_button = %ResetKey

	super()


func _is_valid_event(event):
	return event is InputEventKey


func _encode_events(events):
	var keycodes: Array[int] = []

	for key in events:
		keycodes.append(key.physical_keycode)

	return keycodes


func _decode_events(encoded_events):
	var gen_keys: Array[InputEvent] = []

	for keycode in encoded_events:
		if not keycode is int:
			continue

		var input := InputEventKey.new()

		input.physical_keycode = keycode
		gen_keys.append(input)

	return gen_keys


func _check_equivalent_inputs(input_a, input_b):
	return input_a.physical_keycode == input_b.physical_keycode


func _get_human_name(event):
	var keycode: int = DisplayServer.keyboard_get_keycode_from_physical(event.physical_keycode)
	return OS.get_keycode_string(keycode)
