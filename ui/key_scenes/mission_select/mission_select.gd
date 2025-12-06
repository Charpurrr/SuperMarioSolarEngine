extends KeyScene

@export var startup_sound: AudioStream


func _ready() -> void:
	super()
	SFX.play_sfx(startup_sound, &"Music", self)
