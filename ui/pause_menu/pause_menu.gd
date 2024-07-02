class_name PauseMenu
extends Control
## Pause menu functionality. Does not handle functionality for its children.

@export var contents_menu: VBoxContainer
@export var bindings_menu: VBoxContainer
@export var bindings_button: Button


func _ready():
	visible = false
	bindings_menu.visible = false


func enable_disable():
	visible = !visible


func _on_bindings_pressed():
	contents_menu.visible = !contents_menu.visible
	bindings_menu.visible = !bindings_menu.visible
