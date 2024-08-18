class_name Submerged
extends PlayerState
## A base state for being submerged in water.


func _on_enter(_handover):
	movement.activate_consec_timer()
	movement.consume_freefall_timer()
	movement.air_spun = false
	movement.dived = false


func _physics_tick():
	if not actor.vel.is_equal_approx(Vector2.ZERO):
		actor.doll.rotation = actor.vel.angle()

		movement.update_direction(sign(actor.vel.x))

		if actor.doll.flip_h:
			actor.doll.rotation += PI


func _on_exit():
	actor.doll.rotation = 0


func _trans_rules():
	if not movement.is_submerged():
		return &"Dry"

	return &""


func _defer_rules():
	return &"SwimIdle"
