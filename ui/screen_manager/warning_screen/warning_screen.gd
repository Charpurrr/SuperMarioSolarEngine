class_name WarningScreen
extends Screen
## A confirmation dialogue screen with editable text.

@export var warning_text: RichTextLabel

## The text that replaces the placeholder text.
var text: String
## Which function should run when the confirm button is pressed.
## If new behaviour is desired, a new function can be created in this script.
var confirm_behaviour: Callable


func on_load():
	warning_text.text = text


func restart() -> void:
	GameState.emit_reload()
	manager.switch_screen(self)


func quit() -> void:
	get_tree().quit()


func _on_cancel_pressed() -> void:
	manager.switch_screen(self, manager.pause_screen)


func _on_confirm_pressed() -> void:
	confirm_behaviour.call()
