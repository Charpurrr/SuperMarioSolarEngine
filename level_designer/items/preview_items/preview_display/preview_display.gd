@tool
class_name PreviewDisplayData
extends Resource
## Stores data about a preview item display node.
##
## Stores data about a preview item display node,
## allowing it to be created and added to a [PreviewItem].


func create() -> Node2D:
	return Node2D.new()


func get_selection_shape() -> Shape2D:
	return null


func set_selection_shape(_shape: Shape2D):
	pass


func needs_static_selection_shape() -> bool:
	return false


func get_reference_texture() -> Texture2D:
	return null
