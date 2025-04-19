class_name IconMap
extends Node
## Utility class for finding the associated icon with an InputEvent.


static var icon_map: Resource = preload("res://ui/input_icons/icon_dictionary.tres")
static var _event_map: Dictionary = {}


static func _static_init() -> void:
	if !_event_map:
		for _event: InputEvent in icon_map.dictionary:
			if _event != null:
				_event_map.set(_event.as_text().hash(), _event)


static func find(event: InputEvent) -> CompressedTexture2D:
	return icon_map.dictionary.get(_event_map.get(event.as_text().hash()), null)
