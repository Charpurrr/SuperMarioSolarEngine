class_name UIBindButton
extends UIButton
## A UI button specifically for binding inputs to actions.

## The action name as defined in the project's [InputMap].
## In the [OptionsScreen], this is overwritten by the [BindSetting] value of the same name.
@export var action_name: StringName
## The type of InputEvents this bind button listens to.
## Simply add an unconfigured InputEvent of your desired type to the array
## to allow it to be parsed.
## In the [OptionsScreen], this is overwritten by the [BindSetting] value of the same name.
@export var parsable_events: Array[InputEvent]
## Maximum amount of binds this action can have at once.
@export_range(0, 100, 1,"hide_slider") var max_binds: int
## Sound effect that plays when an input gets denied.
@export var deny_sfx: AudioStreamWAV

@export_category("References")
@export var timer: Timer

@export var icons: HBoxContainer
var bound_inputs: PackedStringArray

var awaiting_input: bool = false
var timeout_timer: SceneTreeTimer

## The default input events as present in the project's [InputMap].
var default_events: Array
## The inputs of the action filtered by the type of input.
## (I.e. [InputEventKey], [InputEventJoypadButton], ...)
var filtered_events: Array[InputEvent]


func _ready() -> void:
	super()

	focus_entered.connect(_focus_changed)
	focus_exited.connect(_focus_changed)

	var action_path: String = "input/" + action_name
	var action_data: Dictionary = ProjectSettings.get(action_path)
	default_events = action_data["events"]

	# If saved data is found, set the binding to that.
	if LocalSettings.has_setting("Keyboard Bindings (Player: %d)" % 0, action_name):
		var saved_data: PackedStringArray = LocalSettings.load_setting(
			"Keyboard Bindings (Player: %d)" % 0,
			action_name,
			PackedStringArray()
		)

		for event_name: String in saved_data:
			var event: InputEvent = IconMap.get_associated_event(event_name)

			_add_input(event, event_name)
			_add_icon(event)
	# Otherwise, set it to the events defined in the project's [InputMap].
	else:
		for event: InputEvent in default_events:
			if _is_valid_event(event):
				_add_input(event, IconMap.get_filtered_name(event))
				_add_icon(event)


func _input(event: InputEvent) -> void:
	if has_focus():
		if Input.is_action_just_pressed(&"setting_reset"):
			_reset_to_default()
		elif Input.is_action_just_pressed(&"setting_clear"):
			_clear()

	if event is InputEventMouseMotion or not awaiting_input:
		return

	_return_to_idle()

	if not _is_valid_event(event):
		_reject()
		return

	var event_name: String = IconMap.get_filtered_name(event)

	if not icons.get_child_count() >= max_binds and not bound_inputs.has(event_name):
		_add_input(event, event_name)
		_add_icon(event)
	else:
		_reject()


func _focus_changed() -> void:
	## Makes the icons appear as white (the default color) when focused,
	## similar to other instances of icons in UIButtons.
	icons.material.set_shader_parameter(&"enabled", !has_focus())


## Adds the actual event to the project's [InputMap].
func _add_input(event: InputEvent, event_name: String) -> void:
	bound_inputs.append(event_name)
	filtered_events.append(event)

	if not InputMap.action_has_event(action_name, event):
		InputMap.action_add_event(action_name, event)

	var event_to_string: PackedStringArray
	for filtered_event in filtered_events:
		event_to_string.append(IconMap.get_filtered_name(filtered_event))

	LocalSettings.change_setting(
		"Keyboard Bindings (Player: %d)" % 0,
		action_name,
		event_to_string
	)


## Adds the icon of the binding to the button.
func _add_icon(event: InputEvent) -> void:
	var texture_rect := TextureRect.new()

	texture_rect.texture = IconMap.find(event)
	texture_rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	texture_rect.use_parent_material = true

	icons.add_child(texture_rect)


func _clear() -> void:
	bound_inputs.clear()
	filtered_events.clear()

	for event_icon in icons.get_children():
		event_icon.queue_free()

	for bound_event in InputMap.action_get_events(action_name):
		InputMap.action_erase_event(action_name, bound_event)

	LocalSettings.change_setting(
		"Keyboard Bindings (Player: %d)" % 0,
		action_name,
		PackedStringArray()
	)


func _reset_to_default() -> void:
	_clear()

	for event in default_events:
		if _is_valid_event(event):
			_add_input(event, IconMap.get_filtered_name(event))
			_add_icon(event)


func _reject() -> void:
	SFX.play_sfx(deny_sfx, &"UI", self)
	modulate = Color.RED

	var tween := self.create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)


func _return_to_idle():
	focus_mode = Control.FOCUS_ALL
	grab_focus()

	icons.visible = true
	text = ""

	awaiting_input = false


## Checks if an event is parsable by using the defined classes in [member parsable_events].
func _is_valid_event(event: InputEvent) -> bool:
	for event_type: InputEvent in parsable_events:
		if event.is_class(event_type.get_class()):
			return true

	return false


func _on_pressed() -> void:
	awaiting_input = true
	icons.visible = false

	focus_mode = Control.FOCUS_NONE

	timer.start()

	while(awaiting_input):
		text = "Awaiting input (%d)" % ceil(timer.time_left)
		awaiting_input = timer.time_left != 0

		await get_tree().process_frame

	_return_to_idle()
