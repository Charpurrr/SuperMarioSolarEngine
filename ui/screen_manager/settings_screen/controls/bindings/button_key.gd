class_name KeyBindButton
extends Button
## A keyboard input button for a bind option in the bindings menu.

## The key events as present in the project setting's InputMap.
var settings_key_events: Array[InputEventKey]
var current_binds: Array[InputEventKey]

@onready var reset_button = %ResetKey
@onready var clear_button = %ClearKey
@onready var internal_name = get_parent().internal_name
@onready var settings_events = InputMap.action_get_events(internal_name)

@onready var response_timer = $KeyTimer
var awaiting_response: bool = false


func _ready():
	for event in settings_events:
		if event is InputEventKey:
			settings_key_events.append(event)

	current_binds = settings_key_events.duplicate()

	var saved_keys = LocalSettings.load_setting(
		"Controls",
		internal_name,
		_key_to_keycode(settings_key_events)
	)

	var gen_keys: Array[InputEventKey] = []

	for keycode in saved_keys:
		var input = InputEventKey.new()

		input.physical_keycode = keycode
		gen_keys.append(input)

	_update_input(gen_keys)


func _input(event):
	if not awaiting_response:
		return
	if not event is InputEventKey:
		return

	get_viewport().set_input_as_handled()

	awaiting_response = false

	_add_input(event)


func _add_input(input: InputEventKey):
	for bind in current_binds:
		if input.physical_keycode == bind.physical_keycode:
			return

	current_binds.append(input)
	_update_input(current_binds)


func _update_input(new_binds: Array[InputEventKey]):
	for bind in current_binds:
		InputMap.action_erase_event(internal_name, bind)

	for bind in new_binds:
		InputMap.action_add_event(internal_name, bind)

	LocalSettings.change_setting("Controls", internal_name, _key_to_keycode(new_binds))

	current_binds = new_binds.duplicate()

	_set_text(current_binds)
	_update_clear_state()
	_update_reset_state()


func _key_to_keycode(keys: Array[InputEventKey]) -> Array[int]:
	var keycodes: Array[int] = []

	for key in keys:
		keycodes.append(key.physical_keycode)

	return keycodes


func _set_text(events: Array[InputEventKey]):
	var names: Array = []

	for event in events:
		var keycode: int = DisplayServer.keyboard_get_keycode_from_physical(event.physical_keycode)
		names.append(OS.get_keycode_string(keycode))

	text = ", ".join(names)


func _update_reset_state():
	reset_button.disabled = _should_disable_reset()


func _should_disable_reset() -> bool:
	if current_binds.size() != settings_key_events.size():
		return false

	for i in current_binds.size():
		if current_binds[i].physical_keycode != settings_key_events[i].physical_keycode:
			return false

	return true


func _update_clear_state():
	clear_button.disabled = _should_disable_clear()


func _should_disable_clear() -> bool:
	return current_binds.is_empty()


func _on_pressed():
	#if response_timer.time_left != 0:
	response_timer.start()

	awaiting_response = true
	text = "..."

	# timeout
	await response_timer.timeout

	awaiting_response = false
	_set_text(current_binds)


func _on_reset_key_pressed():
	_update_input(settings_key_events)


func _on_clear_key_pressed():
	# Empty binds array
	_update_input([])
