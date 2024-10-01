class_name Bind
extends HBoxContainer
## A binding option for the bindings menu.

@export var visual_name: StringName
@export var internal_name: StringName
## Recommended size: 48x48 pixels
@export var action_icon: Texture2D

@onready var label: Label = $Label
@onready var button_keyboard: Button = $KeyButton
@onready var button_joy: Button = $JoyButton
@onready var texture: TextureRect = $TextureRect

var options: VBoxContainer


func _ready():
	label.text = visual_name
	texture.texture = action_icon


func setup_buttons(device_port: int, player: int):
	for bind_button in get_children():
		if bind_button is BindButton:
			bind_button.setup(device_port, player)


func set_label_w(new_width: float):
	label.custom_minimum_size.x = new_width


func get_label_w() -> float:
	return label.size.x
