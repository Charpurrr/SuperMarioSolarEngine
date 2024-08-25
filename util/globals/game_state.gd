extends Node

signal reload
signal paused

signal frame_advanced

var bgm_muted: bool = false

## Whether or not you can advance a frame.
var can_fa: bool = false

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
	_frame_advancing()
	_music_control()

	if is_inside_tree() and get_tree().paused and event.is_action_pressed(&"frame_advance"):
		can_fa = true


## Frame advancing only works while paused.
func _frame_advancing():
	if not can_fa:
		return

	get_tree().paused = false

	await get_tree().process_frame
	frame_advanced.emit()

	get_tree().paused = true
	can_fa = false


func _music_control():
	if Input.is_action_just_pressed(&"mute"):
		bgm_muted = !bgm_muted

		LocalSettings.change_setting("Audio", "music_muted", bgm_muted)
		_set_muted_bgm()


func _set_muted_bgm():
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), bgm_muted)


## Called with the paused signal.
func pause_toggle():
	get_tree().paused = !get_tree().paused


func emit_reload():
	reload.emit()
