extends Node

@export var startup_sound: AudioStream


func _ready() -> void:
	SFX.play_sfx(startup_sound, &"Music", self)
