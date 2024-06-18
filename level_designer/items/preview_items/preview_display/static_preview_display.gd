@tool
class_name StaticPreviewDisplayData
extends PreviewDisplayData

@export var texture: Texture2D
@export var selection_shape: Shape2D


func create():
	var inst = Sprite2D.new()
	inst.texture = texture
	return inst


func get_selection_shape():
	return selection_shape


func set_selection_shape(shape: Shape2D):
	selection_shape = shape


func needs_static_selection_shape():
	return true


func get_reference_texture() -> Texture2D:
	return texture
