class_name KeyBindButton
extends Button
## A keyboard input button for a bind option in the bindings menu.

## The key event as present in the project setting's InputMap.
var settings_key_event: InputEventKey
var current_bind: InputEventKey

var awaiting_response: bool = false
var received_response: bool = false

@onready var bind = get_parent()
@onready var reset_button = $"../ResetKey"  # Sorry.
@onready var internal_name = bind.internal_name
@onready var events = InputMap.action_get_events(internal_name)


func _ready():
	for event in events:
		if event is InputEventKey:
			settings_key_event = event

	current_bind = settings_key_event

	var saved_key = LocalSettings.load_setting("Controls", internal_name, settings_key_event)

	_update_input(saved_key)


func _input(event):
	if not awaiting_response:
		return
	if not event is InputEventKey:
		return

	get_viewport().set_input_as_handled()

	awaiting_response = false
	received_response = true

	_update_input(event)


func _update_input(new_bind: InputEventKey):
	InputMap.action_erase_event(internal_name, current_bind)
	InputMap.action_add_event(internal_name, new_bind)

	LocalSettings.change_setting("Controls", internal_name, new_bind)

	current_bind = new_bind

	_set_text(current_bind)
	_update_reset_state()


func _set_text(event: InputEventKey):
	var keycode: int = DisplayServer.keyboard_get_keycode_from_physical(event.physical_keycode)
	text = OS.get_keycode_string(keycode)


func _update_reset_state():
	reset_button.disabled = current_bind.physical_keycode == settings_key_event.physical_keycode


func _on_pressed():
	var timer: SceneTreeTimer = get_tree().create_timer(1.0)

	awaiting_response = true
	text = "..."

	# timeout
	await timer.timeout

	if received_response:
		return

	awaiting_response = false
	_set_text(current_bind)


func _on_reset_key_pressed():
	_update_input(settings_key_event)
