class_name ScreenManager
extends Control
## Root node of a screen manager.
## Manages the transitions between different screens.

@export var cursor_sfx: AudioStreamPlayer
@export var color_blur: ColorRect
@export var anime_player: AnimationPlayer

@export_category("Screens")
@export var pause_screen: PauseScreen
@export var warning_screen: WarningScreen


func _ready() -> void:
	# Plays the cursor sound effect when switching between buttons.
	# unbind(1) unbinds the node argument from gui_focus_changed,
	# so it doesn't interfere with play()'s from_position parameter.
	get_viewport().gui_focus_changed.connect(cursor_sfx.play.unbind(1))

	var pass_downs = {
		&"manager": self,
	}

	for child in get_children():
		if child is not Screen:
			continue

		for key in pass_downs:
			child.call_deferred(&"set", key, pass_downs[key])


## Leave from or to as null if wanting to transition out of or into gameplay.
func switch_screen(from: Screen = null, to: Screen = null) -> void:
	if not from == null:
		from.call_deferred(&"_on_exit")

		SFX.play_sfx(from.close_sfx, &"UI", self)

		if from.close_anim == &"BACKWARDS":
			anime_player.play_backwards(from.open_anim)
		else:
			anime_player.play(from.close_anim)

		get_viewport().gui_release_focus()

		await anime_player.animation_finished

		from.visible = false

	if to == null:
		return

	SFX.play_sfx(to.open_sfx, &"UI", self)

	to.visible = true

	anime_player.play(to.open_anim)

	to.focus_grabber.grab_focus()

	await anime_player.animation_finished

	to.call_deferred(&"_on_enter")


#func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	#if not enabled:
		#get_viewport().gui_release_focus()
		#visible = false
	#elif anim_name == &"pause_peek":
		#anime_player.play(&"warning_peek")
