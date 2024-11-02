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
	manager.warning_screen.text = """
	[center]Restart the level from the beginning?
	(Any unsaved progress will be [color=red]LOST[/color].)"""

	manager.warning_screen.confirm_behaviour = manager.warning_screen.restart

	manager.switch_screen(self, manager.warning_screen)


func _on_action_guide_pressed() -> void:
	pass # Replace with function body.


func _on_options_pressed() -> void:
	manager.switch_screen(self, manager.options_screen)


func _on_quit_pressed() -> void:
	manager.warning_screen.text = """
	[center]Exit to title screen?
	(Any unsaved progress will be [color=red]LOST[/color].)"""

	manager.warning_screen.confirm_behaviour = manager.warning_screen.quit

	manager.switch_screen(self, manager.warning_screen)
