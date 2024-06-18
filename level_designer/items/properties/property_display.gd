class_name PropertyDisplay
extends Node2D
## Handles the display of properties in the editor.


## The preview item this property affects.
@onready var preview: PreviewItem = get_parent()


## Called when the associated property is changed externally.
func property_changed(_new_value: Variant) -> void:
	pass


## Can be called to alter the value of the associated property.
func change_property(_new_value: Variant) -> void:
	pass
