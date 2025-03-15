@tool
extends UISlider

## Set in [VolumeSetting].
@onready var bus: AudioBus


func _set_initial_val():
	await owner.ready

	var saved_volume: float = LocalSettings.load_setting("Audio", bus.setting_name, default_value)
	slider.set_value_no_signal(saved_volume)
	_update_slider(saved_volume, false)


func _update_slider(value: float, play_sfx: bool = true) -> void:
	progress.value = value
	grabber_point.progress_ratio = value / max_value

	# If not playing on ready, and no sound effects are 
	# playing in the UI audio bus:
	if play_sfx and get_tree().get_nodes_in_group(&"UI").is_empty():
		SFX.play_sfx(tick_sound, &"UI", self, linear_to_db(value / 50))
