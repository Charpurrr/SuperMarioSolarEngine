class_name LevelEditorUI
extends CanvasLayer

@export_category(&"UI Buttons")
@export var z_toggle: CheckButton
@export var z_layer: SpinBox

@export_category(&"Popup Windows")
@export var quit_confirm: ConfirmationDialog
@export var search_menu: Panel

@export_category(&"Other Elements")
@export var toolbar: Toolbar


func _ready():
	get_window().min_size = Vector2i(800, 300)


func _process(_delta):
	_z_view_behaviour()


func _unhandled_input(event):
	if event.is_action_pressed(&"e_toggle_ui"):
		visible = not visible


func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		quit_confirm.visible = true


func _z_view_behaviour():
	z_layer.editable = z_toggle.button_pressed


func _on_quit_confirm_confirmed():
	get_tree().quit()


func _on_search_pressed():
	search_menu.visible = not search_menu.visible
