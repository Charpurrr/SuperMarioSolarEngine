class_name PauseMenu
extends Control
## Pause menu functionality. Does not handle functionality for its children.

@export var choices: VBoxContainer

#@export var contents_menu: VBoxContainer
#@export var controls_menu: VBoxContainer
#@export var bindings_button: Button


func _ready():
	choices.resume.pressed.connect(_resume)
	choices.retry.pressed.connect(_retry)
	choices.quit.pressed.connect(_quit)

	visible = false
	#controls_menu.visible = false


func enable_disable():
	visible = !visible


func _resume():
	GameState.emit_signal(&"paused")
	enable_disable()


func _retry():
	GameState.emit_signal(&"reload")


func _quit():
	get_tree().quit()


#func _on_bindings_pressed():
	#contents_menu.visible = !contents_menu.visible
	#controls_menu.visible = !controls_menu.visible
