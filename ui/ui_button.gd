class_name PauseButton
extends Button
## A common UI button.

@export var press_sfx: AudioStream


func _ready() -> void:
	pressed.connect(avfx)


## The audio visual effects of a pause button.
func avfx() -> void:
	SFX.play_sfx(press_sfx, &"UI", self)

	# Could optionally add visual effects too, I relied on the button themes instead.
