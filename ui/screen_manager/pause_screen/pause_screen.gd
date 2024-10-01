class_name PauseScreen
extends Screen
## Main pause screen functionality.


func _on_resume_pressed() -> void:
	GameState.paused.emit()
	manager.switch_screen(self)


func _on_retry_pressed() -> void:
	GameState.emit_reload()
	manager.switch_screen(self)


func _on_reset_pressed() -> void:
	manager.switch_screen(self, manager.warning_screen)


func _on_action_guide_pressed() -> void:
	pass # Replace with function body.


func _on_settings_pressed() -> void:
	pass


func _on_quit_pressed() -> void:
	manager.switch_screen(self, manager.warning_screen)
	#get_tree().quit()
