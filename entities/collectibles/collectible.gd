class_name Collectible
extends AnimatedSprite2D
## Abstract class for collectibles. Anything that reacts to being grabbed by the player
## extends from this.

## Reference to the player that's only set when collected.
var player: Player


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		player = body
		_on_collect()


## Overwritten by the parent class.
func _on_collect():
	# Default behaviour simply removes the collectible from the stage when collected.
	queue_free()
