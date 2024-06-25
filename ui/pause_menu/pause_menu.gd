class_name PauseMenu
extends Control
## Pause menu functionality. Does not handle functionality for its children.


func _ready():
	visible = false


func enable_disable():
	visible = !visible
