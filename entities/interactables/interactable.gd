@abstract
class_name Interactable
extends AnimatedSprite2D
## Abstract class for interactables. Anything that reacts to the player'ss
## "interact" input, extends from this.[br][br]
## Examples include doors, npcs, ...

const PULSE_MATERIAL: Resource = preload("res://entities/interactables/interactable.tres")

## Area that defines where the play can interact with this object.
@export var area: Area2D
## Reference to the player that's only set when they enter the [Area2D].
var player: Player
## Whether or not the player is in the interaction area.
var player_near: bool = false


@abstract
func _on_interact() -> void


func _ready() -> void:
	area.body_entered.connect(_interaction_area_entered)
	area.body_exited.connect(_interaction_area_exited)


func _input(_event: InputEvent) -> void:
	if player_near and Input.is_action_just_pressed(&"interact"):
		_on_interact()


func _interaction_area_entered(body: Node2D) -> void:
	if body is Player:
		player = body
		player_near = true
		material = PULSE_MATERIAL


func _interaction_area_exited(body: Node2D) -> void:
	if body is Player:
		player_near = false
		material = null
