class_name SceneTransition
extends Control
## Class used to instance nice-looking scene transitions.

## Emitted when a transition overlay has finished animating.
signal transition_finished

enum Overlay {PLAIN, CIRCULAR}

var from: Overlay
var to: Overlay


## to: What scene to transition into.
## from_overlay: Which visual overlay gets used for the transition from the previous scene.
## to_overlay: Which visual overlay gets used for the transition to the new scene.
## overlay_speed: How fast the overlay animates. (in seconds)
## fake_delay: How many seconds are inbetween the scene transitions.
## Can be used to create a fake loading effect. 
func _init(
	to_scene: PackedScene,
	from_overlay: Overlay = Overlay.PLAIN,
	to_overlay: Overlay = Overlay.PLAIN,
	overlay_speed: float = 0.2,
	fake_delay: float = 0,
) -> void:

	from = from_overlay
	to = to_overlay


func _process(_delta: float) -> void:
	pass # hhhhhhhhhhhhhhhhhhhwhat br ooo


func _plain_transition(speed: float, delay: float) -> void:
	var plain_overlay := ColorRect.new()

	plain_overlay.color = Color(0, 0, 0, 0)

	var tween := create_tween()
	tween.tween_property(plain_overlay, ^"color:a", 1, speed)

	print("nothing")
