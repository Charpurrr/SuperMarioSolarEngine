class_name PauseScreen
extends Control
## Pause screen functionality.

@export var choices: VBoxContainer
@export var pause_menu: HBoxContainer
@export var settings_menu: Control

@export var anime_player: AnimationPlayer

@export_category("Sound Effects")
@export var open_sfx: AudioStreamPlayer
@export var cursor_sfx: AudioStreamPlayer
@export var resume_sfx: AudioStreamPlayer


var enabled: bool = false

var selected_button: Panel


func _ready():
	visible = false
	update_settings_visibility(false)

	selected_button = choices.resume
	get_viewport().gui_focus_changed.connect(focus_updated)


func _input(event: InputEvent) -> void:
	if not enabled:
		return

	if event.is_action_pressed(&"gui_accept"):
		match selected_button:
			choices.resume:
				_resume()
			choices.retry:
				_retry()
			choices.restart:
				_restart()
			choices.guide:
				_guide()
			choices.settings:
				_settings()
			choices.quit:
				_quit()


func enable_disable_screen():
	enabled = !enabled

	if enabled:
		visible = true

		open_sfx.play()
		anime_player.play(&"peek")

		choices.resume.grab_focus()
	else:
		anime_player.play_backwards(&"peek")
		# See _on_animation_player_animation_finished()


## Updates the color of the focused button inside of the entire pause screen,
## and undoes any color modulation done on previously focused buttons.
## Then plays the cursor sound effect associated with focusing a button.
func focus_updated(new_button: Panel) -> void:
	cursor_sfx.play()

	selected_button.self_modulate = Color.WHITE
	selected_button = get_viewport().gui_get_focus_owner()
	new_button.self_modulate = Color.PURPLE


func update_settings_visibility(settings_visible: bool):
	pause_menu.visible = !settings_visible
	settings_menu.visible = settings_visible


func _resume():
	resume_sfx.play()
	GameState.paused.emit()
	enable_disable_screen()


func _retry():
	GameState.emit_reload()
	enable_disable_screen()


func _restart():
	pass


func _guide():
	pass


func _settings():
	update_settings_visibility(true)


func _quit():
	get_tree().quit()


func _on_return_settings_pressed():
	update_settings_visibility(false)


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	if not enabled:
		get_viewport().gui_release_focus()
		visible = false
