extends Node

signal setting_initialised(key: String, value: Variant)

@warning_ignore("unused_signal")
# Is used primarily for WorldMachine communication,
# but makes more sense to store here.
signal reload
signal paused

var debug_toggle: bool = false

var fullscreened: bool = false

var bgm_muted: bool = false
var buses: Dictionary[StringName, AudioBus] = {
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

	# Run the logic of every setting on ready
	setting_initialised.connect(_setting_changed.bind())
	# Run the logic of every setting when it is changed
	LocalSettings.setting_changed.connect(_setting_changed.bind())

	process_mode = Node.PROCESS_MODE_ALWAYS

	bgm_muted = LocalSettings.load_setting("Audio", "music_muted", false)
	_set_muted_bgm()

	debug_toggle = LocalSettings.load_setting("Developer", "debug_toggle", false)


#func _process(_delta: float) -> void:
	#print(get_tree().get_nodes_in_group(&"UI"))


func _unhandled_input(event):
	if event.is_action_pressed(&"mute"):
		_music_control()

	# Toggle between fullscreen and last non-fullscreen window scale
	if event.is_action_pressed(&"fullscreen"):
		var scale: int

		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			scale = WindowSizer.last_none_fs
		else:
			scale = WindowSizer.MAX_SCALE

		LocalSettings.change_setting("General", "scale", scale)
		WindowSizer.set_win_size(scale)

	if event.is_action_pressed(&"debug_toggle"):
		debug_toggle = !debug_toggle
		LocalSettings.change_setting("Developer", "debug_toggle", debug_toggle)


func _music_control():
	bgm_muted = !bgm_muted

	LocalSettings.change_setting("Audio", "music_muted", bgm_muted)
	_set_muted_bgm()


func _set_muted_bgm():
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), bgm_muted)


func _setting_changed(key: String, value: Variant):
	match key:
		# GENERAL
		"v_sync":
			DisplayServer.window_set_vsync_mode(value)
		"fps_cap":
			Engine.max_fps = 30 * value # 0:INF, 1:30, 2:60, 3: 120
		"scale":
			WindowSizer.set_win_size(value)
		# DEVELOPER
		"debug_toggle":
			debug_toggle = value


## Called with the paused signal.
func pause_toggle():
	get_tree().paused = !is_paused()

	if not bgm_muted:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), is_paused())


func is_paused() -> bool:
	return get_tree().paused
