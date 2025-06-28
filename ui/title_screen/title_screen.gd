extends KeyScreen

@export var anime: AnimationPlayer
@export var focus_grabber: UIButton
@export_category(&"Scenes")
@export var play_scene: PackedScene
@export var edit_scene: PackedScene
@export var rec_scene: PackedScene

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == &"start":
		anime.play(&"logo_float")
		focus_grabber.grab_focus()


func _on_play_pressed() -> void:
	get_tree().change_scene_to_packed(play_scene)


func _on_edit_pressed() -> void:
	get_tree().change_scene_to_packed(edit_scene)


func _on_record_pressed() -> void:
	get_tree().change_scene_to_packed(rec_scene)
