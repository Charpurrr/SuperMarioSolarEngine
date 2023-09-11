class_name State
extends Node
# A base state that every state extends from


@onready var actor : Node = owner

@export_group("Sounds", "sfx_")
@export var sfx_sound_effects : Array # What sound effects this state should play
@export var sfx_quit_sfx_on_exit : bool # If the sound effect should keep playing after the state's on_exit()
@export var sfx_sfx_delay : float # How long the state should wait until playing a sound effect (in seconds)

@export_group("Animation", "anim_")
@export var anim_animation_name : StringName # What animation this state should play
@export var anim_offset_x : float # This state's animation's offset on the x axis
@export var anim_offset_y : float # This state's animation's offset on the x axis

@export var current_substate : State


## Returns the substates dictionary from the superstate.
func get_states() -> Dictionary:
	var parent : Node = get_parent()

	if parent is State: # Check if the node calling this function is a substate
		return parent.substates

	return {} # Null


## Runs on every process loop.
func tick(_delta): 
	pass


## Runs on every physics process loop.
func physics_tick(_delta): 
	pass


## Runs when the state is activated.
func on_enter(): 
	pass


## Runs when the state is deactivated.
func on_exit(): 
	pass


## Check if you should switch states.
func switch_check() -> State: 
	return null


## switch_check that incorporates all substates.
func parent_switch_check(): 
	if current_substate != null:
		var new_state = current_substate.switch_check()

		if new_state != null:
			seek_state(new_state)

		if current_substate != null: # current_substate might change during seek_state()
			current_substate.parent_switch_check()


## Finds a path to a given state and calls it.
func seek_state(target_state : State): 
	var path : NodePath = get_path_to(target_state)
	var current_state : State = self

	for i in path.get_name_count():
		var next_name : String = path.get_name(i)
		
		var next_state = current_state.get_node(next_name)

		if current_state.is_ancestor_of(target_state):
			current_state.change_state(next_state)
		else:
			abandon_state()

		current_state = next_state


## Return the lowest state in the currently active state tree.
func get_lowest_state() -> State: 
	if current_substate == null: 
		return self
	else:
		return current_substate.get_lowest_state()


func abandon_state():
	if current_substate == null: return

	if get_lowest_state().sfx_quit_sfx_on_exit == true:
		actor.audio.stop()

	current_substate.on_exit()
	
	# Needs to be recursive.
	# We can't use call_with_substates because current_substate is set to null after this function ends.
	# So, manual recursion is used.
	current_substate.abandon_state()
	current_substate = null


## Switch between states.
func change_state(new_state : State): 
#	print("-------")
#	print(current_substate)
#	print(new_state)

	if new_state == current_substate: return
	
	if current_substate != null:
		abandon_state()

	current_substate = new_state

	enter_state()


func enter_state():
	if current_substate == null: return

	var lowest_state : State = get_lowest_state()

	current_substate.on_enter()

	actor.doll.offset.x = current_substate.anim_offset_x * actor.movement.facing_direction
	actor.doll.offset.y = current_substate.anim_offset_y

	if lowest_state.sfx_sound_effects != null:
		var sfx_amt : int = lowest_state.sfx_sound_effects.size() # Amount of sound effects in the sound effects array

		if sfx_amt != 0:
			actor.audio.play_sfx(lowest_state, lowest_state.sfx_sfx_delay)

	if current_substate.anim_animation_name != "":
		print(current_substate.anim_animation_name)
		actor.doll.play(current_substate.anim_animation_name)


## Returns the sound effects array of this state.
func get_sfx() -> Array: 
	return sfx_sound_effects


func call_with_substate(function : StringName, arguments : Array = []): # Handles function interaction between the super and sub states
	var callable := Callable(self, function)

	callable.callv(arguments)

	if current_substate != null:
		current_substate.call_with_substate(function, arguments)
