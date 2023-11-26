class_name Wallslide
extends PlayerState
## Holding the facing direction against a wall while airborne.


const TERM_VEL: float = 1.10


func _on_enter(_handover):
	actor.vel.y = min(actor.vel.y, TERM_VEL)


func _post_tick():
	actor.movement.apply_gravity(1, 8)


func _tell_switch():
	if actor.movement.should_end_wallslide():
		return &"Fall"

	if actor.movement.active_buffer_jump():
		return &"Walljump"

	if Input.is_action_just_pressed("down"):
		return &"GroundPound"

	return &""
