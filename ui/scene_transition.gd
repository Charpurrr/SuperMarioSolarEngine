@tool
class_name SceneTransition
extends Control
## Class used to instance nice-looking scene transitions.

## Emitted when a transition overlay has finished animating.
signal transition_finished

@export_tool_button("Preview") var preview_action = _preview
@export var preview_to: TransitionOverlay
@export var preview_from: TransitionOverlay





### to: What scene to transition into.
### from_overlay: Which visual overlay gets used for the transition from the previous scene.
### to_overlay: Which visual overlay gets used for the transition to the new scene.
### overlay_speed: How fast the overlay animates. (in seconds)
### fake_delay: How many seconds are inbetween the scene transitions.
### Can be used to create a fake loading effect. 
#func _init(
	#to_scene: PackedScene,
	#between_logic: Callable,
	#from_overlay: Overlay = Overlay.PLAIN,
	#to_overlay: Overlay = Overlay.PLAIN,
	#overlay_speed: float = 0.2,
#) -> void:
#
	#from = from_overlay
	#to = to_overlay

func _ready():
	pass


func _start_transition(to: TransitionOverlay, from: TransitionOverlay) -> void:
	to.show()
	from.hide()
	to.play_transition(Color.WHITE, 1.0, false)
	await to.animation.animation_finished
	to.hide()
	from.show()
	from.play_transition(Color.WHITE, 1.0, true)
	await to.animation.animation_finished
	transition_finished.emit()


func _preview() -> void:
	for child in get_children():
		child.visible = false
	var children = get_children()
	if preview_to == null:
		preview_to = children[randi() % children.size()]
	if preview_from == null:
		preview_from = children[randi() % children.size()]
	_start_transition(preview_to, preview_from)
