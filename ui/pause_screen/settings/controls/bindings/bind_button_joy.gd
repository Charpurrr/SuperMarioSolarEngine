class_name JoyBindButton
extends BindButton
## A bind button catered towards joypad (controller) inputs.
## Lots of functions in this script are defined by its parent class.
## See [BindButton] for descriptions and types.

const PREFIX_BUTTON: String = "B"
const PREFIX_MOTION: String = "M"

## For getting human-readable names of [InputEventJoypadButton]s.[br]
## The array is sorted by brand based on its ID in [method _get_brand_id].
const JOY_BUTTONS: Array = [
	["B", "A", "x"],
	["A", "B", "◯"],
	["Y", "X", "□"],
	["X", "Y", "△"],
	["L", "LB", "L1"],
	["R", "RB", "R1"],
	["-", "Back", "Select"],
	["+", "Start", "Start"],
	["Left Stick Click", "Left Stick Click", "Left Stick Click"],
	["Right Stick Click", "Right Stick Click", "Right Stick Click"],
	["ZL", "LT", "L2"],
	["ZR", "RT", "R2"],
	["Logo", "Logo", "Logo"],
	["D-Up", "D-Up", "D-Up"],
	["D-Down", "D-Down", "D-Down"],
	["D-Left", "D-Left", "D-Left"],
	["D-Right", "D-Right", "D-Right"],
]


func _ready():
	input_device_name = &"Controller"

	response_timer = $JoyTimer
	clear_button = %ClearJoy
	reset_button = %ResetJoy


func _is_valid_event(event):
	return event is InputEventJoypadButton or event is InputEventJoypadMotion


func _encode_events(events):
	var encoded_events: PackedStringArray = []

	for event in events:
		var encoded_event: String = ""

		if event is InputEventJoypadButton:
			encoded_event = "%s%d" % [PREFIX_BUTTON, event.button_index]
		elif event is InputEventJoypadMotion:
			encoded_event = "%s%d:%d" % [PREFIX_MOTION, event.axis, event.axis_value]

		encoded_events.append(encoded_event)

	return encoded_events


func _decode_events(encoded_events):
	var decoded_events: Array[InputEvent] = []

	for event in encoded_events:
		if not event is String:
			continue

		if event.begins_with(PREFIX_BUTTON):
			var input := InputEventJoypadButton.new()

			input.button_index = int(event.trim_prefix(PREFIX_BUTTON)) as JoyButton
			decoded_events.append(input)
		elif event.begins_with(PREFIX_MOTION):
			var event_split = event.trim_prefix(PREFIX_MOTION).split(":")
			var input := InputEventJoypadMotion.new()

			input.axis = int(event_split[0]) as JoyAxis
			input.axis_value = float(event_split[1])
			decoded_events.append(input)

	return decoded_events


func _check_equivalent_inputs(input_a, input_b):
	if not input_a.get_class() == input_b.get_class():
		return false

	if input_a is InputEventJoypadButton:
		return input_a.button_index == input_b.button_index

	if input_a is InputEventJoypadMotion:
		return input_a.axis == input_b.axis and input_a.axis_value == input_b.axis_value


func _get_human_name(event):
	if event is InputEventJoypadButton:
		return JOY_BUTTONS[event.button_index][_get_brand_id()]

	if event is InputEventJoypadMotion:
		return "Axis" + str(event.axis) + "[" + str(event.axis_value) + "]"


func _check_outside_deadzone(event):
	if event is InputEventJoypadButton:
		return true

	if event is InputEventJoypadMotion:
		return abs(event.axis_value) > InputMap.action_get_deadzone(internal_name)


func _clean_input(input):
	if input is InputEventJoypadMotion:
		input.axis_value = sign(input.axis_value)

	return input


## Returns a number based on vendor ID.
func _get_brand_id():
	if Input.get_connected_joypads().size() == 0:
		return 0

	var guid = Input.get_joy_guid(device_port)
	var vendor_id = guid.substr(8, 4)

	print(guid)

	match vendor_id:
		"7e05", "d620": # Nintendo
			return 0
		"5e04": # Microsoft
			return 1
		"1716", "7264", "4c05", "510a", "ce0f", "ba12": # Sony
			return 2
		_: # Unidentified
			var warning_text: String = (
				"""Unidentified joypad device or brand in port %d.
				Update this function and the JOY_BUTTONS array to support it""" %
				device_port
			)

			push_warning(warning_text)

			return 0
