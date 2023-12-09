class_name PAVManager
extends AVManager
## Audiovisual manager specifically for player characters.


@export var movement: PMovement
@export var player: Player


func _ready():
	for child in get_children():
		child.movement = movement
		child.player = player
