extends Node

signal frame_advanced
signal paused

var bgm_muted: bool = false

const FRAME_TIME: int = 2
var frame_timer: int

## Whether or not you can advance a frame.
var can_fa: bool = false

var buses: Dictionary = {
	&"Master":
		AudioBus.new(
			&"Master",
			"Master Volume",
		),
	&"Music":
		AudioBus.new(
			&"Music",
			"BGM Volume",
		),
	&"SFX":
		AudioBus.new(
			&"SFX",
			"SFX Volume",
		)
}


func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

	bgm_muted = LocalSettings.load_setting("Audio", "Music Muted", false)
	_set_muted_bgm()


func _process(_delta):
	_frame_advancing()
	_music_control()
	_resetting()
	_pausing()

	if is_inside_tree() and get_tree().paused and Input.is_action_just_pressed(&"frame_advance"):
		can_fa = true


## Frame advancing only works while paused.
func _frame_advancing():
	if not can_fa:
		frame_timer = FRAME_TIME
		return

	get_tree().paused = false
	frame_timer = max(frame_timer - 1, 0)

	if frame_timer == 0:
		emit_signal(&"frame_advanced")

		get_tree().paused = true
		can_fa = false


func _pausing():
	if Input.is_action_just_pressed(&"pause"):
		get_tree().paused = !get_tree().paused
		emit_signal(&"paused")


func _music_control():
	if Input.is_action_just_pressed(&"mute"):
		bgm_muted = !bgm_muted

		LocalSettings.change_setting("Audio", "Music Muted", bgm_muted)
		_set_muted_bgm()


func _set_muted_bgm():
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), bgm_muted)


func _resetting():
	if Input.is_action_just_pressed(&"reset"):
		var tree = get_tree()

		if tree:
			tree.reload_current_scene()
