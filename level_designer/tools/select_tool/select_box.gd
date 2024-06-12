class_name SelectionBox
extends NinePatchRect
## Object selector for the level designer.


@export var area: Area2D
@export var shape: CollisionShape2D
## In frames.
@export var animation_delay: float
var timer: float = 0

var selected_previews: Array = []


func _ready():
	timer = animation_delay


func _process(_delta):
	timer = max(timer - 1, 0)

	if timer == 0:
		region_rect.position.x = wrap(region_rect.position.x + 28, 0, 140)
		timer = animation_delay


func _on_area_2d_body_entered(body):
	selected_previews.append(body)
