extends Control

@export var anime: AnimationPlayer
@export_category(&"Choices")
@export var play: Button
@export var play_scene: PackedScene
@export var edit: Button
@export var edit_scene: PackedScene


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == &"start":
		anime.play(&"logo_float")
		play.grab_focus()


func _on_play_pressed() -> void:
	get_tree().change_scene_to_packed(play_scene)


func _on_edit_pressed() -> void:
	get_tree().change_scene_to_packed(edit_scene)
