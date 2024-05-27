class_name Notification
extends AnimatedSprite2D
## Pop-up notifications, warnings, or errors.


@onready var label: Label = $Label

## Type of notification. (I.e. error, warning, push)
var type: StringName
## What the notification should say.
var input: String


func _ready():
	animation = type
	label.text = input


func _process(delta):
	modulate.a = move_toward(255, 0, delta)


func _on_animation_player_animation_finished(_anim_name):
	queue_free()
