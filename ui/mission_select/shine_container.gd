@tool
class_name ShineContainer
extends CarouselContainer
## Carousel container with some extra tweaks to work nicely for the mission select menu.


func _ready() -> void:
	wraparound = get_child_count() > 2


func _while_selected(shine: Node):
	shine = shine as AnimatedTextureRect

	if not shine.playing:
		shine.play()


func _while_deselected(shine: Node):
	shine = shine as AnimatedTextureRect
	shine.stop()
