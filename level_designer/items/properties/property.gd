class_name Property
extends Resource

## Name of the property. Corresponds with a variable name on the spawned item.
@export var property_name: StringName

## Whether or not this property will display in the in-game property list.
@export var show_in_properties: bool = false

## Data type of the property.
@export var data_type: Variant.Type

## TODO: rewrite docu
@export var display: PropertyDisplayData
