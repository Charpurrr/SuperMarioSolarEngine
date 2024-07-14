class_name ControlsMenu
extends VBoxContainer
## Controls menu functionality.

@export var bindings_list: VBoxContainer

@export var fake_label: Control
@export var header_keyboard: Label
@export var header_controller: Label

@onready var bindings_children: Array[Node] = bindings_list.get_children()


func _ready():
	_update_header()


## Updates the header for the bindings to fit correctly
func _update_header():
	var biggest_w: float

	for child in bindings_children:
		biggest_w = max(biggest_w, child.get_label_w())

	for child in bindings_children:
		child.set_label_w(biggest_w)

	fake_label.custom_minimum_size.x = biggest_w
