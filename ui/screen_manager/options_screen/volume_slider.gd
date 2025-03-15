@tool
extends UISlider

## Set in [VolumeSetting].
@onready var bus: AudioBus


func _set_initial_val():
	await owner.ready

	if not Engine.is_editor_hint():
		var saved_volume: float = LocalSettings.load_setting("Audio", bus.setting_name, default_value)
		slider.value = saved_volume
	else:
		super()


func _try_sfx():
	# If not playing on ready, and no sound effects are 
	# playing in the UI audio bus:
	if get_tree().get_nodes_in_group(&"UI").is_empty():
		SFX.play_sfx(tick_sound, &"UI", self, linear_to_db(value / 100))
