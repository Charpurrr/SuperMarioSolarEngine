class_name Airborne
extends PlayerState
## A base state for all airborne states.


func _physics_tick():
	actor.set_floor_snap_length(0.0)

	if actor.is_on_ceiling() and not live_substate is GroundPound:
		for sfx_list in sfx_layers:
			SFXLayer.play_sfx(self, sfx_list, force_new)


func _trans_rules():
	if actor.is_on_floor():
		return [&"Grounded", not live_substate is GroundPound]

	if movement.active_coyote_time() and input.buffered_input(&"jump"):
		return &"Jump"

	return &""


func _tell_defer():
	return &"Fall"
