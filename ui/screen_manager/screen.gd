class_name Screen
extends Control
## Abstract class for a screen that gets handled by a screen manager.

## The sound effect that plays when this screen is transitioned to.
@export var open_sfx: AudioStream
## The sound effect that plays when this screen is transitioned to.
@export var close_sfx: AudioStream
## The name of the menu opening animation as seen in the screen manager's AnimationPlayer.
@export var open_anim: StringName
## The name of the menu opening animation as seen in the screen manager's AnimationPlayer. [br][br]
## Note: You can choose to simply play the opening animation backwards by entering « BACKWARDS »
## in all caps in this field.
@export var close_anim: StringName
## Which node grabs focus when this screen is opened.
@export var focus_grabber: Control

## Whether or not this screen is enabled.
var enabled: bool = false

## Set by the screen manager node.
var manager: ScreenManager


## Ran once when this screen is transitioned to.
func _on_enter() -> void:
	pass


## Ran once when this screen is transitioned from.
func _on_exit() -> void:
	pass
