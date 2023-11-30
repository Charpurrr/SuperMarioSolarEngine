class_name PAVManager
extends AVManager
## Audiovisual manager specifically for player characters.


@onready var movement: PMovement = %Movement


func _ready():
	for child in get_children():
		child.movement = movement
