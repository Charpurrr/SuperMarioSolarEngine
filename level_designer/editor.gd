class_name LevelEditor
extends Node
## Base class for the level editor.


@export var user_interface: CanvasLayer
@export var quit_confirm: ConfirmationDialog

func _ready():
	get_tree().set_auto_accept_quit(false)
