class_name State
extends Node
# A base state that every state extends from


@onready var actor : Node = owner

@export var sound_effects : Array # What sound effecet this state should play

@export var animation_name : StringName # What animation this state should play
@export var offset_x : float # This state's animation's offset on the x axis
@export var offset_y : float # This state's animation's offset on the x axis

@export var current_substate : State


func get_states() -> Dictionary: # Returns the substates dictionary from the superstate
	var parent : Node = get_parent()

	if parent is State: # Check if the node calling this function is a substate
		return parent.substates

	return {} # Null


func tick(_delta): # Runs on every process loop
	pass


func physics_tick(_delta): # Runs on every physics process loop
	pass


func on_enter(): # Runs when the state is activated
	pass


func on_exit(): # Runs when the state is deactivated
	pass


func switch_check() -> State: # Check if you should switch states
	return null


func parent_switch_check(): # switch_check that incorporates all substates
	if current_substate != null:
		var new_state = current_substate.switch_check()

		if new_state != null:
			if new_state.get_parent() == self:
				current_substate.abandon_state()
				change_state(new_state)
			else:
				seek_state(new_state)

		if current_substate != null: # current_substate might change during seek_state()
			current_substate.parent_switch_check()


func seek_state(target_state : State): # Finds a path to a given state and calls it
	var path : NodePath = get_path_to(target_state)
	var current_state : State = self

	for i in path.get_name_count():
		var parent_name : String = path.get_name(i)

		if current_state.is_ancestor_of(target_state):
			current_state.change_state(current_state.get_node(parent_name))
		else:
			abandon_state()

		current_state = current_state.get_node(parent_name)


func abandon_state():
	if current_substate == null: return

	actor.audio.stop()

	current_substate.on_exit()
	current_substate.call_with_substate("abandon_state")
	current_substate = null


func change_state(new_state : State): # Switch between states
	if current_substate != null:
		abandon_state()

	current_substate = new_state
	enter_state()


func enter_state():
	if current_substate == null: return

	current_substate.call_with_substate("on_enter")

	actor.doll.offset.x = current_substate.offset_x * actor.movement.facing_direction
	actor.doll.offset.y = current_substate.offset_y

	if current_substate.sound_effects != null:
		var sfx_amt : int = current_substate.sound_effects.size() # Amount of sound effects in the sound effects array

		if sfx_amt != 0:
			actor.audio.play_sfx(current_substate.sound_effects)

	if current_substate.animation_name != "":
		actor.doll.play(current_substate.animation_name)


func call_with_substate(function : StringName, arguments : Array = []): # Handles function interaction between the super and sub states
	var callable := Callable(self, function)

	callable.callv(arguments)

	if current_substate != null:
		current_substate.call_with_substate(function, arguments)
