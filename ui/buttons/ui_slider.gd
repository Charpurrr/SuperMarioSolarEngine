@tool
class_name UISlider
extends Control
## A common UI slider, with a range of 0 to 100.[br]
## The script runs in the editor to update the visuals accordingly.

# TODO: Add ticks, but there's a bug in Godot that prevents this.
# ISSUE LINK: https://github.com/godotengine/godot/issues/103839

@export_range(0, 100) var default_value: float = 50
#@export var ticked: bool = false:
	#set(val):
		#ticked = val
#
		#if is_instance_valid(slider):
			#_update_ticks()

@export_category("References")
@export var slider: HSlider
@export var grabber: Control
@export var progress_bar: ProgressBar
@export var tick_sound: AudioStream

var initialising: bool = false

func _ready() -> void:
	initialising = true

	slider.value = default_value
	_update_slider(default_value)

	initialising = false

#func _update_ticks():
	#if ticked == true:
		#slider.tick_count = round(size.x / 8)
	#else:
		#slider.tick_count = 0

# This function is called when the slider's value changes,
# setting the grabber and progress bar to match,
# and playing the sound effect.
func _update_slider(value: float) -> void:
	# Update the progress bar.
	progress_bar.value = value
	
	# Set the left and right anchors of the grabber,
	# according to the value.
	# This moves the grabber to the right location.
	grabber.set_anchor(SIDE_LEFT, value / 100, true)
	grabber.set_anchor(SIDE_RIGHT, value / 100, true)
	
	# If not playing on ready, and no sound effects are 
	# playing in the UI audio bus:
	if not initialising and get_tree().get_nodes_in_group(&"UI").is_empty():
		SFX.play_sfx(tick_sound, &"UI", self)
