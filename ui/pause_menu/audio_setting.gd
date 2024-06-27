class_name AudioSetting
extends HBoxContainer
## An audio setting in the pause menu.
## Contains a reset button, a slider, and a label.

@export var bus_name: StringName
@export var reset: Button
@export var slider: HSlider
@export var percentage: Label

@onready var bus: AudioBus = GameState.buses[bus_name]


func _ready():
	reset.pressed.connect(_reset_pressed)
	slider.value_changed.connect(_slider_updated)

	slider.value = bus.current_vol_linear


func _slider_updated(new_value: float):
	bus.update_volume(new_value)

	reset.disabled = new_value == 1.0
	percentage.text = "%d%%" % (new_value * 100)


func _reset_pressed():
	slider.value = 1.0
