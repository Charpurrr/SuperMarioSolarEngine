extends Node

signal reload
signal paused

var bgm_muted: bool = false

var buses: Dictionary = {
	&"Master":
	(
		AudioBus
		.new(
			&"Master",
			"master_volume",
		)
	),
	&"Music":
	(
		AudioBus
		.new(
			&"Music",
			"bgm_volume",
		)
	),
	&"SFX":
	(
		AudioBus
		.new(
			&"SFX",
			"sfx_volume",
		)
	)
}


func _ready():
	paused.connect(pause_toggle)

	process_mode = Node.PROCESS_MODE_ALWAYS

	bgm_muted = LocalSettings.load_setting("Audio", "music_muted", false)
	_set_muted_bgm()


func _unhandled_input(event):
	if event.is_action_pressed(&"mute"):
		_music_control()


func _music_control():
	bgm_muted = !bgm_muted

	LocalSettings.change_setting("Audio", "music_muted", bgm_muted)
	_set_muted_bgm()


func _set_muted_bgm():
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), bgm_muted)


## Called with the paused signal.
func pause_toggle():
	get_tree().paused = !is_paused()

	if not bgm_muted:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), is_paused())


func is_paused() -> bool:
	return get_tree().paused


func emit_reload():
	reload.emit()
