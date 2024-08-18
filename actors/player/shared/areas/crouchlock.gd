class_name CrouchlockDetection
extends Area2D
## Detect when the player needs to be forced into the crouch state.

var enabled: bool = false


func _physics_process(_delta):
	enabled = has_overlapping_bodies()
