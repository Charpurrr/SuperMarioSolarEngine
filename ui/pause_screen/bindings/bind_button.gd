class_name BindButton
extends Button
## Abstract class for control binding buttons.

## The events as present in the project setting's InputMap.
## Filtered by the type of input. (Keyboard, controller, ...)
var filtered_settings_events: Array
var current_binds: Array

## Should be set in the child class' _ready().
var input_device_name: StringName = &"Unidentified Device Type"
## Should be set in the child class' _ready().
var reset_button: Button = null
## Should be set in the child class' _ready().
var clear_button: Button = null
## Should be set in the child class' _ready().
var response_timer: Timer
var awaiting_response: bool = false

@onready var internal_name: StringName = get_parent().internal_name
@onready var settings_events: Array[InputEvent] = InputMap.action_get_events(internal_name)


func _ready():
	for event in settings_events:
		if _is_valid_event(event):
			filtered_settings_events.append(event)

	current_binds = filtered_settings_events.duplicate()

	var saved_events = LocalSettings.load_setting(
		input_device_name + " Bindings",
		internal_name,
		_encode_events(filtered_settings_events)
	)

	_update_input(_decode_events(saved_events))

	clear_button.pressed.connect(_clear_bindings)
	reset_button.pressed.connect(_reset_bindings)
	pressed.connect(_on_pressed)


func _input(event):
	if not awaiting_response:
		return
	if not _is_valid_event(event):
		return
	if not _check_outside_deadzone(event):
		return

	get_viewport().set_input_as_handled()

	awaiting_response = false

	_add_input(event)


#region Overriden Functions
## Should be overridden by the child class.
## Returns [code]true[/code] if the event is of the right type.[br]
## For example:
## [codeblock]
## func _is_valid_event(event: InputEvent) -> bool:
##     return event is InputEventKey
## [/codeblock]
## This will filter all InputEvents for Keys. (keyboard inputs).
## It will ignore every other kind of input. (Controller, mouse, ...)
func _is_valid_event(_event: InputEvent) -> bool:
	push_warning("This function should be overridden in a child class.")
	return false


## Should be overridden by the child class.[br][br]
## Defines how inputs get encoded in the [LocalSettings] file.[br]
## E.g. [InputEventKey] as keycode, [InputEventJoyButton] as button_index, etc.
func _encode_events(_events: Array) -> Array:
	push_warning("This function should be overridden in a child class.")
	return []


## Should be overridden by the child class.[br][br]
## Defines how inputs get decoded from the [LocalSettings] file.[br]
## E.g. keycode as [InputEventKey], button_index as [InputEventJoyButton], etc.
func _decode_events(_encoded_events: Array) -> Array:
	push_warning("This function should be overridden in a child class.")
	return []


## Should be overridden by the child class.[br][br]
## Defines how inputs are compared.
func _check_equivalent_inputs(_input_a: InputEvent, _input_b: InputEvent) -> bool:
	push_warning("This function should be overridden in a child class.")
	return false


## Should be overridden by the child class.[br][br]
## Defines what shows up in the [BindButton] label.
func _get_human_name(_event: InputEvent) -> StringName:
	push_warning("This function should be overridden in a child class.")
	return &""


## Can be overridden by the child class, but not required.[br][br]
## Returns whether or not an input with a deadzone (as set in [ProjectSettings])
## is outside of its deadzone, and therefor usable.[br]
## Digital inputs do not require this function, so it defaults to true.
func _check_outside_deadzone(_event: InputEvent) -> bool:
	return true


## Can be overridden by the child class, but not required.[br][br]
## Defines how inputs get "cleaned up".[br]
## E.g. normalising joystick input.
func _clean_input(input: InputEvent) -> InputEvent:
	return input
#endregion


func _add_input(input: InputEvent):
	var cleaned_input: InputEvent = _clean_input(input)

	for bind in current_binds:
		if _check_equivalent_inputs(cleaned_input, bind):
			return

	current_binds.append(_clean_input(input))
	_update_input(current_binds)


func _update_input(new_binds: Array):
	for bind in current_binds:
		InputMap.action_erase_event(internal_name, bind)

	for bind in new_binds:
		InputMap.action_add_event(internal_name, bind)

	LocalSettings.change_setting(
		input_device_name + " Bindings",
		internal_name,
		_encode_events(new_binds)
	)

	current_binds = new_binds.duplicate()

	_set_text(current_binds)
	_update_clear_state()
	_update_reset_state()


func _set_text(events: Array):
	var names: Array = []

	for event in events:
		names.append(_get_human_name(event))

	text = ", ".join(names)


func _reset_bindings():
	_update_input(filtered_settings_events)


func _update_reset_state():
	reset_button.disabled = _should_disable_reset()


func _should_disable_reset() -> bool:
	if current_binds.size() != filtered_settings_events.size():
		return false

	for i in current_binds.size():
		if not _check_equivalent_inputs(current_binds[i], filtered_settings_events[i]):
			return false

	return true


func _clear_bindings():
	_update_input([])


func _update_clear_state():
	clear_button.disabled = _should_disable_clear()


func _should_disable_clear() -> bool:
	return current_binds.is_empty()


func _on_pressed():
	response_timer.start()

	awaiting_response = true
	text = "..."

	# timeout
	await response_timer.timeout

	awaiting_response = false
	_set_text(current_binds)
