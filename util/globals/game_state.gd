extends Node

@warning_ignore("unused_signal")
# Is used primarily for WorldMachine communication,
# but makes more sense to store here.
signal reload
signal paused

signal debug_toggled
var debug_toggle: bool = false

var fullscreened: bool = false

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

	if LocalSettings.load_setting("Window", "fullscreened", false) == true:
		toggle_fullscreen()

	bgm_muted = LocalSettings.load_setting("Audio", "music_muted", false)
	_set_muted_bgm()

	debug_toggle = LocalSettings.load_setting("Developer", "debug_toggled", false)


#func _process(delta: float) -> void:
	#print(debug_toggle)


func _unhandled_input(event):
	if event.is_action_pressed(&"mute"):
		_music_control()

	if event.is_action_pressed(&"fullscreen"):
		toggle_fullscreen()

	if event.is_action_pressed(&"debug_toggle"):
		debug_toggle = !debug_toggle
		LocalSettings.change_setting("Developer", "debug_toggled", debug_toggle)
		debug_toggled.emit()


func _music_control():
	bgm_muted = !bgm_muted

	LocalSettings.change_setting("Audio", "music_muted", bgm_muted)
	_set_muted_bgm()


func _set_muted_bgm():
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), bgm_muted)


func toggle_fullscreen():
	if fullscreened == false:
		get_window().mode = Window.MODE_FULLSCREEN
		fullscreened = true
	else:
		get_window().mode = Window.MODE_WINDOWED
		fullscreened = false

	LocalSettings.change_setting("Window", "fullscreened", fullscreened)


## Called with the paused signal.
func pause_toggle():
	get_tree().paused = !is_paused()

	if not bgm_muted:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), is_paused())


func is_paused() -> bool:
	return get_tree().paused
