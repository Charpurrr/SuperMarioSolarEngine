class_name UserInterface
extends CanvasLayer
# UI and utility


var bgm_muted: bool = false

const FRAME_TIME: int = 2
var frame_timer: int

## Whether or not you can advance a frame.
var can_fa: bool = false


func _ready():
	bgm_muted = LocalSettings.load_setting("Audio", "Music Muted", false)

	set_muted_bgm()


func _process(_delta):
	music_control()
	advance_frame()
	resetting()
	pausing()

	if get_tree().paused == true and Input.is_action_just_pressed(&"frame_advance"):
		can_fa = true


## Frame advancing only works while paused.
func advance_frame():
	if not can_fa:
		frame_timer = FRAME_TIME
		return

	get_tree().paused = false
	frame_timer = max(frame_timer - 1, 0)

	if frame_timer == 0:
		get_tree().paused = true
		can_fa = false


func pausing():
	if Input.is_action_just_pressed(&"pause"):
		get_tree().paused = !get_tree().paused


func music_control():
	if Input.is_action_just_pressed(&"mute"):
		bgm_muted = !bgm_muted

		LocalSettings.change_setting("Audio", "Music Muted", bgm_muted)
		set_muted_bgm()


func set_muted_bgm():
	AudioServer.set_bus_mute(AudioServer.get_bus_index("BGM"), bgm_muted)


func resetting():
	if Input.is_action_just_pressed(&"reset"):
		get_tree().reload_current_scene()
