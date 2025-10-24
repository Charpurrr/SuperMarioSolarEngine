@abstract
class_name Collectible
extends AnimatedSprite2D
## Abstract class for collectibles. Anything that reacts to being grabbed by the player
## extends from this.[br][br]
## Examples include coins, power-ups, ...

@export var area: Area2D
## Reference to the player that's only set when collected.
var player: Player

## Can be overwritten by the parent class.
func _on_collect() -> void:
	# Default behaviour simply removes the collectible from the stage when collected.
	queue_free()


func _ready() -> void:
	area.body_entered.connect(_check_body_player)


## Checks whether or not the body interaction was from a player.
## If that's the case, run [method _on_collect].
func _check_body_player(body: Node2D) -> void:
	if body is Player:
		player = body
		_on_collect()
