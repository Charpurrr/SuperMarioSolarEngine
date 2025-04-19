class_name IconMap
extends Node
## Utility class for finding the associated icon with an InputEvent.


static var icon_map: Resource = preload("res://ui/input_icons/icon_dictionary.tres")


static func find(event: InputEvent) -> CompressedTexture2D:
	return icon_map.dictionary.get(event, null)
