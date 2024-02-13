class_name CrouchlockDetection
extends Area2D
## Detect when the player needs to be forced into the crouch state.


var crouchlock_enabled: bool = false


func _on_body_entered(body):
	if body is StaticBody2D:
		crouchlock_enabled = true
	else:
		crouchlock_enabled = false
