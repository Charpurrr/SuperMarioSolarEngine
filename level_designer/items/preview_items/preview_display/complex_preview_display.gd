@tool
class_name ComplexPreviewDisplayData
extends PreviewDisplayData

@export var preview_scene: PackedScene


func create():
	return preview_scene.instantiate()
