extends Control

#Class for key screens, such as the Title Screen, Level Select screen,  Game World, or others that the TransitionManager can warp to if needed

class_name KeyScene

enum return_code {ERROR, OK, WAIT}
const message: Dictionary = {
	return_code.ERROR : "Something went wrong that I can't figure out. Weird... Stay here for now.",
	return_code.OK : "Everything checks out! Enjoy your flight!",
	return_code.WAIT: "Woah, buddy! Cool your jets! I'll let you go in a second."
	}

func _ready() -> void:
	TransitionManager.current_key_screen = self
	TransitionManager.emit_signal("ready_to_progress")

func _on_transition_to():
	pass

func _on_transition_from():
	pass

#To be called when attempting a transition to another scene. 
#If you have something to finish before you leave, make sure to put it here! 
#Remember also to use the "signal" message to tell the transition manager to await a certain signal before continuing.
func _try_transition() -> Dictionary: #Key: {result: bool, message: String, signal: Signal()}
	return {"result": true, "message": message[return_code.OK]}
