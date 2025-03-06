@tool
class_name UISlider
extends Control
## A common UI slider.[br]
## The script is a tool script so the visuals update accordingly.

@export_range(0, 100) var default_value = 50

@export_category("References")
@export var slider: HSlider
@export var grabber_path: Path2D
@export var grabber_point: PathFollow2D
@export var grabber_button: Button
@export var grabber_rect: ColorRect
@export var progress: ProgressBar


func _ready() -> void:
	slider.value = default_value

	slider.value_changed.connect(_update_slider)
	resized.connect(_update_size)
	resized.connect(_update_slider.bind(slider.value))

	_update_slider(default_value)
	_update_size()


func _update_size() -> void:
	#progress.size.x = size.x
	progress.size = size
	slider.size.x = size.x
	#grabber_button.size.y = size.y

	grabber_path.curve.clear_points()
	var x: float = size.x - grabber_button.size.x
	var y: float = floor(size.y / 2)
	grabber_path.curve.add_point(Vector2(0, y))
	grabber_path.curve.add_point(Vector2(x, y))


func _update_slider(value: float) -> void:
	progress.value = value
	grabber_point.progress_ratio = value / 100
