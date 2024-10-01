class_name WarningScreen
extends Screen
## A confirmation dialogue screen with editable text.


func _on_cancel_pressed() -> void:
	manager.switch_screen(self, manager.pause_screen)


func _on_confirm_pressed() -> void:
	GameState.emit_reload()
	manager.switch_screen(self)
