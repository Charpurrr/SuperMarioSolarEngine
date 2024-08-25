class_name PauseScreen
extends Control
## Pause screen functionality.

@export var choices: VBoxContainer
@export var pause_menu: HBoxContainer
@export var settings_menu: Control


func _ready():
	#choices.resume.pressed.connect(_resume)
	#choices.retry.pressed.connect(_retry)
	#choices.settings.pressed.connect(_settings)
	#choices.quit.pressed.connect(_quit)

	visible = false
	update_settings_visibility(false)


func enable_disable_screen():
	visible = !visible


func update_settings_visibility(settings_visible: bool):
	pause_menu.visible = !settings_visible
	settings_menu.visible = settings_visible


func _resume():
	GameState.paused.emit()
	enable_disable_screen()


func _retry():
	GameState.emit_reload()
	enable_disable_screen()


func _settings():
	update_settings_visibility(true)


func _quit():
	get_tree().quit()


func _on_return_settings_pressed():
	update_settings_visibility(false)
