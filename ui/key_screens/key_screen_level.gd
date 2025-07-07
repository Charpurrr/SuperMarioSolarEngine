extends KeyScreen

#Class for the Level key screen
class_name KeyScreenLevel

var current_level: Level

func _ready():
	if TransitionManager.scene_transition.in_transition:
		TransitionManager.current_key_screen = self

func _on_transition_to(): #Called when this scene has just been transitioned to.
	pass

func _on_transition_from(): #Called when this scene is about to transition.
	pass

func _try_transition() -> Dictionary: #Key: {result: bool, message: String, signal: Signal()}
	return {"result": true, "message": message[return_code.OK]} #TODO: Add things that the level might need to finish before transitioning
