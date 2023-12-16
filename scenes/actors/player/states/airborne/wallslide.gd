class_name Wallslide
extends PlayerState
## Holding the facing direction against a wall while airborne.


## How fast you can slide downwards during a wallslide.
@export var term_vel: float = 1.10

## If you've started sliding down or not.
var reached_fall: bool


func _on_enter(_handover):
	movement.consume_coyote_timer()


func _cycle_tick():
	reached_fall = actor.vel.y >= 0

	if not reached_fall:
		actor.vel.y = lerp(actor.vel.y, 0.0, 0.2)
	else:
		actor.vel.y = min(actor.vel.y, term_vel)


func _post_tick():
	movement.apply_gravity(1, 8)


func _tell_switch():
	if movement.should_end_wallslide():
		return &"Fall"

	if input.buffered_input(&"jump"):
		return &"Walljump"

	if input.buffered_input(&"spin"):
		return &"Spin"

	if Input.is_action_just_pressed(&"down") and movement.can_air_action():
		return &"GroundPound"

	return &""
