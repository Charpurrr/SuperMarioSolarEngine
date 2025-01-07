@tool
extends Node2D

@export var button: TextureButton

@export_category(&"Visuals")
@export_enum("Common", "Red") var costume: String = "Common":
	set(value):
		costume = value
		_set_appropriate_sprites()

@export var common_costume_data: ButtonCostume
@export var red_costume_data: ButtonCostume


func _set_appropriate_sprites() -> void:
	match costume:
		"Common":
			button.texture_normal = common_costume_data.normal_graphic
			button.texture_hover = common_costume_data.hover_graphic
			button.texture_pressed = common_costume_data.pressed_graphic
		"Red":
			button.texture_normal = red_costume_data.normal_graphic
			button.texture_hover = red_costume_data.hover_graphic
			button.texture_pressed = red_costume_data.pressed_graphic
