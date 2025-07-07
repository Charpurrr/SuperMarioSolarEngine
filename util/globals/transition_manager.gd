#[Insert trans joke here]

extends CanvasLayer


#Handles transitions between the UI and levels, going between levels, and area warps!r

signal ready_for_level

enum TransitionType {TO_SCREEN, TO_LEVEL, WARP_IN_LEVEL}

var current_key_screen: KeyScreen

var level_key_screen := preload("uid://bf8yafuc4b6x7") # Being Level nodes are Node2Ds, This KeyScreen scene is inserted as a parent to the level node when transitioning to one.

@onready var scene_transition = %SceneTransition #Used for accessing outside of this object


func start_transition(uid: String, type: TransitionType, data: Dictionary):
	print(uid)
	if is_instance_valid(current_key_screen):
		await current_key_screen._try_transition()

	match type:

		TransitionType.TO_SCREEN:
			if ResourceLoader.exists(uid):
				await current_key_screen._on_transition_from()
				%SceneTransition.start_transition(%SceneTransition/CircleOverlay, %SceneTransition/CircleOverlay, Color.BLACK)
				await %SceneTransition.transition_to_finished
				var result = get_tree().change_scene_to_file(uid)
				if result:
					%SceneTransition.finish_transition()
		
		TransitionType.TO_LEVEL:
			if ResourceLoader.exists(uid):
				await current_key_screen._on_transition_from()
				%SceneTransition.start_transition(%SceneTransition/CircleOverlay, %SceneTransition/CircleOverlay, Color.BLACK)
				await %SceneTransition.transition_to_finished
				get_tree().change_scene_to_packed(level_key_screen) #Key Screen PackedScene
				await ready_for_level
				var level: WorldMachine = load(uid).instantiate()
				current_key_screen.add_child(level)
				%SceneTransition.finish_transition()
