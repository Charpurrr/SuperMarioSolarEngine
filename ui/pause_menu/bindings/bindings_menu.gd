class_name BindingsMenu
extends VBoxContainer
## Bindings menu functionality.

@export var bindings_list: VBoxContainer
#@export var header: HBoxContainer

@onready var fake_label: Control = $Header/FakeLabel
@onready var header_keyboard: Label = $Header/Keyboard
@onready var header_controller: Label = $Header/Controller

@onready var bindings_children: Array[Node] = bindings_list.get_children()


func _ready():
	var biggest_w: float

	for child in bindings_children:
		biggest_w = max(biggest_w, child.get_label_w())

	for child in bindings_children:
		child.set_label_w(biggest_w)

	fake_label.custom_minimum_size.x = biggest_w
