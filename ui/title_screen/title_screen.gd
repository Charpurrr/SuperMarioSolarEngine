extends Control

@export var cursor_sfx: AudioStreamPlayer
@export var anime: AnimationPlayer
@export_category(&"Choices")
@export var play: Button
@export var play_scene: PackedScene
@export var edit: Button
@export var edit_scene: PackedScene


func _ready() -> void:
	# Plays the cursor sound effect when switching between buttons.
	# unbind(1) unbinds the node argument from gui_focus_changed,
	# so it doesn't interfere with play()'s from_position parameter.
	get_viewport().gui_focus_changed.connect(cursor_sfx.play.unbind(1))


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == &"start":
		anime.play(&"logo_float")
		play.grab_focus()


func _on_play_pressed() -> void:
	get_tree().change_scene_to_packed(play_scene)


func _on_edit_pressed() -> void:
	get_tree().change_scene_to_packed(edit_scene)
