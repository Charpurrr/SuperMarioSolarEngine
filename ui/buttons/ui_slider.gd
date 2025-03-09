@tool
class_name UISlider
extends Control
## A common UI slider.[br]
## The script is a tool script so the visuals update accordingly.

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
@export var grabber_path: Path2D
@export var grabber_point: PathFollow2D
@export var grabber_button: Button
@export var grabber_rect: ColorRect
@export var progress: ProgressBar
@export var tick_sound: AudioStream

var initialising: bool = false


func _ready() -> void:
	initialising = true

	slider.value = default_value

	slider.value_changed.connect(_update_slider)
	resized.connect(_update_size)
	resized.connect(_update_slider.bind(slider.value))

	_update_size()
	_update_slider(default_value)

	initialising = false


#func _process(_delta: float) -> void:
	#print(get_tree().get_nodes_in_group(&"UI"))


func _update_size() -> void:
	progress.size.x = size.x
	slider.size.x = size.x - 2

	#_update_ticks()

	grabber_path.curve.clear_points()
	var x: float = size.x - grabber_button.size.x
	var y: float = floor(size.y / 2)
	grabber_path.curve.add_point(Vector2(0, y))
	grabber_path.curve.add_point(Vector2(x, y))


#func _update_ticks():
	#if ticked == true:
		#slider.tick_count = round(size.x / 8)
	#else:
		#slider.tick_count = 0


func _update_slider(value: float) -> void:
	progress.value = value
	grabber_point.progress_ratio = value / 100

	# If not playing on ready, and no sound effects are 
	# playing in the UI audio bus:
	if not initialising and get_tree().get_nodes_in_group(&"UI").is_empty():
		SFX.play_sfx(tick_sound, &"UI", self)
