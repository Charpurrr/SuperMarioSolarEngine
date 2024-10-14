class_name PauseButton
extends Button
## A common UI button.

@export var press_sfx: AudioStream


func _ready() -> void:
	pressed.connect(avfx)


## The audio visual effects of a pause button.
func avfx() -> void:
	var audio_player := AudioStreamPlayer.new()

	audio_player.set_stream(press_sfx)
	audio_player.set_bus(&"UI")

	add_child(audio_player)

	audio_player.play()
	
	audio_player.connect(&"finished", audio_player.queue_free)

	# Could optionally add visual effects too, I relied on the button themes instead.
