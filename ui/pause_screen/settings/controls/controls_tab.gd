class_name ControlsMenu
extends VBoxContainer
## Controls menu functionality.


@export var motion_toggle: Button

@export var rumble_menu_toggle: Button
@export var rumble_menu: HBoxContainer

@export var bindings_list: VBoxContainer

@export var fake_label: Control
@export var header_keyboard: Label
@export var header_controller: Label

@onready var bindings_children: Array[Node] = bindings_list.get_children()


func _ready():
	_update_rumble_toggle(false)
	_update_header()


func _update_motion_toggle(toggled_on: bool):
	var suffix: String

	if toggled_on:
		suffix = "ENABLED"
	else:
		suffix = "DISABLED"

	motion_toggle.text = "Motion Controls: " + suffix


## Updates the visuals of the rumble menu toggle button according to its state.
func _update_rumble_toggle(toggled_on: bool):
	var prefix: String

	if toggled_on:
		prefix = "Close"
	else:
		prefix = "Open"

	rumble_menu_toggle.text = prefix + " Rumble Settings"
	rumble_menu.visible = toggled_on


## Updates the bindings header for the bindings to fit correctly.
func _update_header():
	var biggest_w: float

	for child in bindings_children:
		biggest_w = max(biggest_w, child.get_label_w())

	for child in bindings_children:
		child.set_label_w(biggest_w)

	fake_label.custom_minimum_size.x = biggest_w


func _on_rumble_menu_toggle_toggled(toggled_on):
	_update_rumble_toggle(toggled_on)


func _on_motion_toggle_toggled(toggled_on):
	_update_motion_toggle(toggled_on)
