class_name PStateCoordinator
extends State
# A method of coordination between a player's states


func _ready():
	await actor.ready

	current_substate.call_with_substate("enter_state")


func _process(delta):
	if current_substate == null:
		return
	current_substate.call_with_substate("tick", [delta])


func _physics_process(delta):
	parent_switch_check()

	if current_substate == null: return
# Robust parent_switch_check() before state coordinator was a state
#	if current_sstate == null:
#		return
#
#	var new_state = current_sstate.switch_check()
#
#	if new_state != null:
#		change_state(new_state)
#
#	current_sstate.parent_switch_check()

	current_substate.call_with_substate("physics_tick", [delta])


#func change_state(new_state : State): # Switch between super states
#	current_sstate.call_with_substate("on_exit")
#	current_sstate = new_state
#	current_sstate.call_with_substate("on_enter")
