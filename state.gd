class_name State
extends Node
# A base state that every state extends from


@onready var actor : Node = owner

@export var animation_name : StringName # What animation this state should play
@export var offset_x : float # This state's animation's offset on the x axis
@export var offset_y : float # This state's animation's offset on the x axis


@warning_ignore("unused_parameter")
func tick(delta): # Runs on every process loop
	pass


@warning_ignore("unused_parameter")
func physics_tick(delta): # Runs on every physics process loop
	pass


func on_enter(): # Runs when the state is activated
	pass


func on_exit(): # Runs when the state is deactivated
	pass


func switch_check() -> State: # Check if you should switch states
	return null
