class_name Airborne
extends PlayerState
## A base state for all airborne states.


func _physics_tick():
	actor.set_floor_snap_length(0.0)


func _trans_rules():
	if actor.is_on_floor():
		return [&"Grounded", not live_substate is GroundPound]

	if movement.active_coyote_time() and input.buffered_input(&"jump"):
		return &"Jump"

	return &""


func _defer_rules():
	return &"Fall"


func _on_ceiling_check_body_entered(body: Node2D) -> void:
	if body is StaticBody2D:
		for sfx_list in sfx_layers:
			sfx_list.play_sfx_at(self)
