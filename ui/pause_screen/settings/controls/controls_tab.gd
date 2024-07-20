class_name ControlsMenu
extends VBoxContainer
## Controls menu functionality.

@export var motion_toggle: Button

@export_category(&"Rumble References")
@export var rumble_menu_toggle: Button
@export var rumble_menu: HBoxContainer
@export var rumble_icon: TextureRect
@export var rumble_progress: ColorRect
@export var rumble_modes: HBoxContainer

var rumble_names: Array[StringName]

@export_category(&"Bindings References")
@export var bindings_list: VBoxContainer

@export var fake_label: Control
@export var header_keyboard: Label
@export var header_controller: Label

@onready var bindings_children: Array[Node] = bindings_list.get_children()


func _ready():
	_update_rumble_visible(false)
	_update_header()

	for mode in rumble_modes.get_children():
		if mode is Button:
			var mode_name = mode.name

			mode.pressed.connect(_update_rumble.bind(mode_name))
			rumble_names.append(mode_name)

	var mode_count = rumble_names.size() - 1

	rumble_progress.size_flags_stretch_ratio = mode_count
	_set_rumble_shader_param(&"segment_count", mode_count)


func _update_motion_toggle(toggled_on: bool):
	var suffix: String

	if toggled_on:
		suffix = "ENABLED"
	else:
		suffix = "DISABLED"

	motion_toggle.text = "Motion Controls: " + suffix


## Updates the visibility of the rumble menu toggle button according to its state.
func _update_rumble_visible(menu_visible: bool):
	var prefix: String

	if menu_visible:
		prefix = "Close"
	else:
		prefix = "Open"

	rumble_menu_toggle.text = prefix + " Rumble Settings"
	rumble_menu.visible = menu_visible


## Updates the rumble setting the relating graphics.
func _update_rumble(strength: StringName):
	var strength_id: int
	var icon_texture = rumble_icon.texture as AtlasTexture

	strength_id = rumble_names.find(strength)

	icon_texture.region.position.x = icon_texture.region.size.x * strength_id

	_set_rumble_shader_param(&"value", strength_id)

	LocalSettings.change_setting("Rumble", "Strength", strength)


func _set_rumble_shader_param(parameter: StringName, value: Variant):
	var rumble_material = rumble_progress.material as ShaderMaterial

	rumble_material.set_shader_parameter(parameter, value)


## Updates the bindings header for the bindings to fit correctly.
func _update_header():
	var biggest_w: float

	for child in bindings_children:
		biggest_w = max(biggest_w, child.get_label_w())

	for child in bindings_children:
		child.set_label_w(biggest_w)

	fake_label.custom_minimum_size.x = biggest_w


func _on_rumble_menu_toggle_toggled(toggled_on):
	_update_rumble_visible(toggled_on)


func _on_motion_toggle_toggled(toggled_on):
	_update_motion_toggle(toggled_on)
