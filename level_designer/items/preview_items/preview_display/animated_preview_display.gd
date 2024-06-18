@tool
class_name AnimatedPreviewDisplayData
extends PreviewDisplayData

@export var animation: StringName
@export var sprite_frames: SpriteFrames
@export var selection_shape: Shape2D


func create():
	var inst = AnimatedSprite2D.new()
	inst.sprite_frames = sprite_frames
	inst.animation = animation
	inst.play()
	return inst


func get_selection_shape():
	return selection_shape


func set_selection_shape(shape: Shape2D):
	selection_shape = shape


func needs_static_selection_shape():
	return true


func get_reference_texture() -> Texture2D:
	return sprite_frames.get_frame_texture(animation, 0)
