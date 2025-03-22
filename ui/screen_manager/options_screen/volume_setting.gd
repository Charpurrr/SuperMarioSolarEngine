class_name VolumeSetting
extends Control
## A volume setting in the options menu.
## Contains a reset button, a slider, and a label.

@export var header_text: String
@export var bus_name: StringName

@export_category("References")
@export var header: Label
@export var reset: Button
@export var slider: UISlider
@export var percentage: Label

@onready var bus: AudioBus = GameState.buses[bus_name]


func _ready():
	slider.slider.value_changed.connect(_slider_updated)
	slider.bus = bus

	header.text = header_text


func _slider_updated(slider_val: float):
	percentage.text = "%d%%" % (slider_val)
	bus.update_volume(slider_val / 100)


func _on_reset_button_pressed() -> void:
	slider.slider.value = slider.default_value
