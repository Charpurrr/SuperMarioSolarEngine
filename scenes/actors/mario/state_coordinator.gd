class_name PStateCoordinator
extends Node
# A method of coordination between a player's states


@export var current_sstate : State = null

@onready var actor : Node = owner


func _ready():
	await actor.ready

	current_sstate.call_with_substate("enter_state")


func _process(delta):
#	print(actor.is_on_floor())

	if current_sstate == null:
		return
	current_sstate.call_with_substate("tick", [delta])


func _physics_process(delta):
	if current_sstate == null:
		return

	var new_state = current_sstate.switch_check()

	if new_state != null:
		change_state(new_state)

	current_sstate.parent_switch_check()
	current_sstate.call_with_substate("physics_tick", [delta])


func change_state(new_state : State): # Switch between super states
	current_sstate.call_with_substate("on_exit")
	current_sstate = new_state
	current_sstate.call_with_substate("on_enter")
