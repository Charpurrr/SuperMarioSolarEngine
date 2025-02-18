class_name UIButtonOptions
extends UIButton
## A UI button that toggles between options when pressed.

## The options that will get toggled between.[br]
## These strings are also what the button's text will show.
@export var options: Array[StringName]

## Which section of the LocalSettings this button's value gets saved to.[br]
## (Leave empty if saving isn't desirable)
@export var save_section: String = ""
## To which key this button's value gets saved.[br]
## (Leave empty if saving isn't desirable)
@export var save_key: String = ""

## Which of the button options is selected.
var selected_option: StringName


func _ready() -> void:
	super()

	selected_option = LocalSettings.load_setting(save_section, save_key, "")

	_update(true)
	pressed.connect(_update)


func _update(initialize: bool = false):
	var i = options.find(selected_option)
	
	# Default to the first option if none is selected.
	if i == -1:
		selected_option = options.front()
	elif not initialize:
		# Cycle to the next option, looping back if necessary.
		selected_option = options[(i + 1) % options.size()]

	text = selected_option

	if not save_section.is_empty() or not save_key.is_empty():
		LocalSettings.change_setting(save_section, save_key, selected_option)
