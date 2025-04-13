@tool
class_name SceneTransition
extends Control
## Class used to instance nice-looking scene transitions.

## Emitted when a transition overlay has finished animating.
signal transition_finished

enum Overlay {PLAIN, CIRCULAR}

@export var preview_overlay: Overlay
@export_tool_button("Preview", "Play") var preview_action = _preview

@export_category("References")
@export var plain_overlay: ColorRect
@export var circ_overlay: ColorRect

var from: Overlay
var to: Overlay


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


func _plain_transition(speed: float) -> void:
	plain_overlay.visible = true

	var tween := create_tween()
	
	if plain_overlay.color.a == 1:
		tween.tween_property(plain_overlay, "color:a", 0, speed)
	else:
		tween.tween_property(plain_overlay, "color:a", 1, speed)

	await tween.finished
	transition_finished.emit()


func _circ_transition(speed: float) -> void:
	circ_overlay.visible = true

	var tween := create_tween()
	
	if circ_overlay.material.get_shader_parameter("circle_size") == 0.0:
		tween.tween_property(circ_overlay.material, "shader_parameter/circle_size", 1.05, speed)
	else:
		tween.tween_property(circ_overlay.material, "shader_parameter/circle_size", 0.0, speed)

	await tween.finished
	transition_finished.emit()


func _preview() -> void:
	for child in get_children():
		child.visible = false

	match preview_overlay:
		Overlay.PLAIN:
			_plain_transition(0.3)
		Overlay.CIRCULAR:
			_circ_transition(0.3)
