class_name UserInterface
extends CanvasLayer
# UI and utility


var bgm_muted : bool = false


func _ready():
	bgm_muted = LocalSettings.load_setting("Audio", "Music Muted", false)

	set_muted_bgm()


func _process(_delta):
	music_control()
	resetting()
	pausing()


func pausing():
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = !get_tree().paused


func music_control():
	if Input.is_action_just_pressed("mute"):
		bgm_muted = !bgm_muted

		LocalSettings.change_setting("Audio", "Music Muted", bgm_muted)
		set_muted_bgm()


func set_muted_bgm():
	AudioServer.set_bus_mute(AudioServer.get_bus_index("BGM"), bgm_muted)


func resetting():
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
