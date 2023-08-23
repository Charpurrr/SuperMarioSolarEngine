class_name PStateCoordinator
extends State
# A method of coordination between a player's states


func _ready():
	await actor.ready

	current_substate.call_with_substate("enter_state")


func _process(delta):
	if current_substate == null: return
	current_substate.call_with_substate("tick", [delta])


func _physics_process(delta):
	parent_switch_check()

	if current_substate == null: return

	current_substate.call_with_substate("physics_tick", [delta])
