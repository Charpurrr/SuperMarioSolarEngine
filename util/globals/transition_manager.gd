#[Insert trans joke here]

extends CanvasLayer


#Handles transitions between the UI and levels, going between levels, and area warps!r

signal ready_to_progress

enum TransitionType {TO_SCREEN, TO_LEVEL, WARP_IN_LEVEL}

var current_key_screen: KeyScreen

@onready var scene_transition = %SceneTransition #Used for accessing outside of this object


func start_transition(uid: String, type: TransitionType, data: Dictionary):
	print(uid)
	if is_instance_valid(current_key_screen):
		await current_key_screen._try_transition()

	match type:

		TransitionType.TO_SCREEN, TransitionType.TO_LEVEL:
			if ResourceLoader.exists(uid):
				await current_key_screen._on_transition_from()
				%SceneTransition.start_transition(%SceneTransition/CircleOverlay, %SceneTransition/CircleOverlay, Color.BLACK)
				await %SceneTransition.transition_to_finished
				var result = get_tree().change_scene_to_file(uid)
				await ready_to_progress
				%SceneTransition.finish_transition()
		
		TransitionType.WARP_IN_LEVEL: #Does a "fake" transition that doesn't load in any scenes
			%SceneTransition.start_transition(%SceneTransition/CircleOverlay, %SceneTransition/CircleOverlay, Color.BLACK)
			await ready_to_progress
			%SceneTransition.finish_transition()
