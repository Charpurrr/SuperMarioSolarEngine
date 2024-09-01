class_name PropertyDisplay
extends Node2D
## Handles the display of properties in the editor.

## The preview display this property affects.
var preview_display: Node2D

## The [PreviewItem] this property affects.
var preview_item: PreviewItem


## Called when the associated property is changed externally.
func value_changed(_new_value: Variant) -> void:
	pass


## Can be called to alter the value of the associated property.
func change_property(_new_value: Variant) -> void:
	pass
