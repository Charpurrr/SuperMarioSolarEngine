extends KeyScreen

@export var anime: AnimationPlayer
@export var focus_grabber: UIButton
@export_category(&"Scenes")
@export_file("*.tscn") var play_scene: String
@export_file("*.tscn") var edit_scene: String
@export_file("*.tscn") var rec_scene: String

func _ready():
	TransitionManager.current_key_screen = self

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == &"start":
		anime.play(&"logo_float")
		focus_grabber.grab_focus()


func _on_play_pressed() -> void:
	TransitionManager.start_transition(ResourceUID.id_to_text(ResourceLoader.get_resource_uid(play_scene)), TransitionManager.TransitionType.TO_LEVEL, {})


func _on_edit_pressed() -> void:
	TransitionManager.start_transition(ResourceUID.id_to_text(ResourceLoader.get_resource_uid(edit_scene)), TransitionManager.TransitionType.TO_SCREEN, {})


func _on_record_pressed() -> void:
	TransitionManager.start_transition(ResourceUID.id_to_text(ResourceLoader.get_resource_uid(rec_scene)), TransitionManager.TransitionType.TO_LEVEL, {})
