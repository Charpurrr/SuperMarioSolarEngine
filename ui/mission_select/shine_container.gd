@tool
class_name ShineContainer
extends CarouselContainer
## Carousel container with some extra tweaks to work nicely for the mission select menu.


func _ready() -> void:
	wraparound = get_child_count() > 2


func _on_selected(shine: Node):
	shine = shine as AnimatedTextureRect
	shine.play()


func _on_deselected(shine: Node):
	shine = shine as AnimatedTextureRect
	shine.stop()
