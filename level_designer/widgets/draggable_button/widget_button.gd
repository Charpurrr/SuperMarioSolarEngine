@tool
class_name DraggableButton
extends Control

signal selected(button: DraggableButton)
signal deselected(button: DraggableButton)
signal delete_attempted

@export var button: TextureButton
@export var x_lock: TextureRect
@export var y_lock: TextureRect

@export_category(&"Visuals")
@export_enum("Common", "Red") var costume: String = "Common":
	set(value):
		costume = value
		_set_appropriate_textures()

@export var common_costume_data: ButtonCostume
@export var red_costume_data: ButtonCostume

@export_category(&"Behaviour")
## Locks the axis of this draggable button so it can only move on the x-axis.[br][br]
## [i]Note that the rotation of its parent defines the axis, not the global world.[/i]
@export var axis_lock_x: bool = false:
	set(value):
		axis_lock_x = value
		if is_instance_valid(x_lock): # To avoid reference issues on the first run of code
			x_lock.visible = value
## Locks the axis of this draggable button so it can only move on the y-axis.[br][br]
## [i]Note that the rotation of its parent defines the axis, not the global world.[/i]
@export var axis_lock_y: bool = false:
	set(value):
		axis_lock_y = value
		if is_instance_valid(y_lock): # To avoid reference issues on the first run of code
			y_lock.visible = value
## Whether or not the button can be dragged around.
@export var draggable: bool = true

var held_down: bool
var hovered_over: bool


func _ready() -> void:
	# To make sure the graphics for the X and Y locks are shown 
	# properly on the first run of the code
	x_lock.visible = axis_lock_x
	y_lock.visible = axis_lock_y


func _process(_delta: float) -> void:
	if draggable and held_down:
		if axis_lock_x:
			global_position.x = get_global_mouse_position().x
		elif axis_lock_y:
			global_position.y = get_global_mouse_position().y
		else:
			global_position = get_global_mouse_position()
	elif hovered_over and Input.is_action_just_pressed("e_delete"):
		# Delete behaviour can be defined by whatever class is using this widget.
		# (If any behaviour should apply at all.)
		delete_attempted.emit()


func _set_appropriate_textures() -> void:
	match costume:
		"Common":
			button.texture_normal = common_costume_data.normal_graphic
			button.texture_hover = common_costume_data.hover_graphic
			button.texture_pressed = common_costume_data.pressed_graphic
		"Red":
			button.texture_normal = red_costume_data.normal_graphic
			button.texture_hover = red_costume_data.hover_graphic
			button.texture_pressed = red_costume_data.pressed_graphic


func _on_button_button_down() -> void:
	selected.emit(self)
	held_down = true


func _on_button_button_up() -> void:
	deselected.emit(self)
	held_down = false


func _on_button_mouse_entered() -> void:
	hovered_over = true


func _on_button_mouse_exited() -> void:
	hovered_over = false
