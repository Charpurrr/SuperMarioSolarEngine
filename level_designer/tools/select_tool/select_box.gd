class_name SelectionBox
extends NinePatchRect
## Object selector for the level designer.

## Area2D that handles item detection.
@export var selection_area: Area2D

## Collision shape for the selection.
@export var shape: CollisionShape2D

## Delay between animation steps in frames.
@export var animation_delay: float
var timer: float = 0


func _ready():
	timer = animation_delay


func _process(_delta):
	timer = max(timer - 1, 0)

	if timer == 0:
		region_rect.position.x = wrap(region_rect.position.x + 28, 0, 140)
		timer = animation_delay
