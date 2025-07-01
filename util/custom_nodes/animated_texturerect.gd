@tool
class_name AnimatedTextureRect
extends TextureRect
## TextureRect that takes in SpriteFrames for its texture.

## It's recommended these sprites are perfectly square.
@export var sprites: SpriteFrames
@export var animation: StringName = "default"
@export var frame: int = 0
@export var speed_scale: float = 1.0
@export var autoplay: bool = false
@export var playing: bool = false

var refresh_rate: float = 1.0
var fps: float = 30.0
var frame_delta: float = 0.0


func _ready() -> void:
	set_animation_data()

	if autoplay:
		play()


func _process(delta: float) -> void:
	if sprites == null or playing == false:
		return

	if sprites.has_animation(animation) == false:
		pause()
		assert(false, "Animation %s does not exist!" % animation)

	set_animation_data()

	frame_delta += speed_scale * delta
	if frame_delta >= refresh_rate / fps:
		texture = get_next_frame()
		frame_delta = 0.0


func get_next_frame():
	frame += 1

	if frame >= sprites.get_frame_count(animation):
		if not sprites.get_animation_loop(animation):
			playing = false
		else:
			frame = 0

	set_animation_data()

	return sprites.get_frame_texture(animation, frame)


func play(new_animation: StringName = animation) -> void:
	frame = 0
	frame_delta = 0.0
	animation = new_animation
	set_animation_data()
	playing = true


func set_animation_data() -> void:
	fps = sprites.get_animation_speed(animation)
	refresh_rate = sprites.get_frame_duration(animation, frame)


func pause() -> void:
	playing = false


func resume() -> void:
	playing = true


func stop() -> void:
	frame = 0
	texture = sprites.get_frame_texture(animation, frame)
	pause()
