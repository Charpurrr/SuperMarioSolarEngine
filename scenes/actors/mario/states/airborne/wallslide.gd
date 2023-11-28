class_name Wallslide
extends PlayerState
## Holding the facing direction against a wall while airborne.


const TERM_VEL: float = 1.10


func _on_enter(_handover):
	movement.consume_coyote_timer()

	actor.vel.y = min(actor.vel.y, TERM_VEL)


func _post_tick():
	movement.apply_gravity(1, 8)


func _tell_switch():
	if movement.should_end_wallslide():
		return &"Fall"

	if input.buffered_input(&"jump"):
		return &"Walljump"

	if Input.is_action_just_pressed(&"down"):
		return &"GroundPound"

	return &""
