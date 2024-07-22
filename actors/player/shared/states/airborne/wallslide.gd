class_name Wallslide
extends PlayerState
## Holding the facing direction against a wall while airborne.

## How fast you can slide downwards during a wallslide.
@export var term_vel: float = 1.10


func _on_enter(_handover):
	movement.consume_coyote_timer()
	movement.consec_jumps = 0


func _physics_tick():
	actor.vel.y = min(actor.vel.y, term_vel)


func _subsequent_ticks():
	movement.apply_gravity(1, 8)


func _trans_rules():
	if input.buffered_input(&"spin"):
		return &"SpinWallbonk"

	if input.buffered_input(&"jump"):
		return [&"Walljump", -movement.facing_direction]

	if movement.should_end_wallslide():
		return &"Fall"

	if Input.is_action_just_pressed(&"groundpound") and movement.can_air_action():
		return &"GroundPound"

	return &""
