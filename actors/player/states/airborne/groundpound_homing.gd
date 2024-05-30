class_name HomingGroundPound
extends PlayerState
## Homing towards objects that have it enabled through the usage of a ground pound.


## How much the groundpound offsets you on the Y axis.
@export var gp_offset: float = -5

@export var linger_time: float = 20
var linger_timer: float

## The horizontal velocity you had before the groundpound, used for FaceplantDives.
var queued_speed: float

var nearby_entities: Array = []


func _on_enter(_handover):
	queued_speed = actor.vel.x

	movement.consume_coyote_timer()
	movement.body_rotation = 0

	actor.vel.y = 0
	actor.vel.x = 0

	actor.doll.rotation = 0
	actor.position.y += gp_offset

	linger_timer = linger_time


func _physics_tick():
	if not actor.doll.is_playing():
		linger_timer = max(linger_timer - 1, 0)


func _trans_rules():
	if not movement.dived and movement.can_air_action() and input.buffered_input(&"dive"):
		return [&"FaceplantDive", queued_speed]

	if linger_timer == 0:
		return &"HomingGroundPoundFall"

	return &""
