class_name WaterExit
extends Fall
## Exiting a body of water by normal means. (Not by spinning)

@export_category(&"Animation (Unique to State)")
@export var animation_jump: StringName
@export var anim_offset_j: Vector2


func _physics_tick():
	_set_appropriate_anim()
	super()


## Sets either the jumping or falling animation depending on velocity.
func _set_appropriate_anim():
	if actor.vel.y < 0:
		actor.doll.play(animation_jump)
	else:
		actor.doll.play(animation)
