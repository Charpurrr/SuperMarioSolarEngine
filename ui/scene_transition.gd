@tool
class_name SceneTransition
extends Control
# Class used to instance nice-looking scene transitions.

## Emitted when the first transition overlay has finished animating.
signal transition_to_finished

## Emitted when a transition overlay has finished animating.
signal prep_finished

## Emitted when the second transition overlay has finished animating.
signal transition_from_finished

@export_tool_button("Preview") var preview_action = _preview
@export var preview_to: TransitionOverlay
@export var preview_from: TransitionOverlay
@export_range(0.1, 999) var wait_time: float #Range prevents an editor crash by setting the timer to 0

var in_transition: bool = false

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
var current_from: TransitionOverlay
var current_to: TransitionOverlay

func _ready():
	pass

func finish_transition():
	call_deferred("emit_signal", "prep_finished") #Calling deferred to allow a frame to sync all of the `await` calls happening during the middle of the transition 

func start_transition(to: TransitionOverlay, from: TransitionOverlay, color: Color) -> void:
	current_to = to
	current_from = from
	in_transition = true
	to.show()
	if to != from:
		from.hide()
	mouse_filter = Control.MOUSE_FILTER_STOP
	to.play_transition(color, 1.0, false)
	await to.animation.animation_finished
	transition_to_finished.emit()
	await prep_finished
	to.hide()
	from.show()
	from.play_transition(color, 1.0, true)
	await from.animation.animation_finished
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	in_transition = false
	transition_from_finished.emit()


func _preview() -> void:
	for child in get_children():
		child.visible = false
	var children = get_children()
	if preview_to == null:
		preview_to = children[randi() % children.size()]
	if preview_from == null:
		preview_from = children[randi() % children.size()]
	start_transition(preview_to, preview_from, Color.WHITE)
	await preview_to.animation.animation_finished
	await get_tree().create_timer(wait_time).timeout
	finish_transition()
