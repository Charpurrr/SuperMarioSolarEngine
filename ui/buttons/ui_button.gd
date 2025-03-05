class_name UIButton
extends Button
## A common UI button.

@export var press_sfx: AudioStream


func _ready() -> void:
	pressed.connect(avfx)


## The audio visual effects of a pause button.
func avfx() -> void:
	SFX.play_sfx(press_sfx, &"UI", self)
	# Could optionally add visual effects too, I relied on the button themes instead.


## Toggle the disabled state of a button. If [code]force_to[/code] is set,
## forces the disabled state to whatever is defined.
## (Leave empty for normal toggling.)[br][br]
## For example: [code]toggle_disable(true)[/code] disables the button
## without minding its previous state.
func toggle_disable(force_to: Variant = null):
	if force_to == null:
		disabled = !disabled
	else:
		disabled = force_to

	if disabled:
		focus_mode = Control.FOCUS_NONE
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		modulate = Color.hex(0x323232ff)
	else:
		focus_mode = Control.FOCUS_ALL
		mouse_filter = Control.MOUSE_FILTER_STOP
		modulate = Color.WHITE


func _on_mouse_entered() -> void:
	grab_focus()


func _on_mouse_exited() -> void:
	release_focus()
