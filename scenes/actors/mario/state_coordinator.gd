class_name PStateCoordinator
extends Node
# A method of coordination between a player's states


@export var current_state : State = null

@onready var actor : Node = owner


func _ready():
	await actor.ready

	enter_state()


func _process(delta):
	print(actor.crouch_lock.has_overlapping_bodies())

	if current_state == null:
		return
	current_state.tick(delta)


func _physics_process(delta):
	if current_state == null:
		return

	var new_state = current_state.switch_check()

	if new_state != null:
		change_state(new_state)

	current_state.physics_tick(delta)


func change_state(new_state : State): # Switch between states
	current_state.on_exit()
	current_state = new_state
	enter_state()


func enter_state():
	actor.doll.play(current_state.animation_name)
	actor.doll.offset.x = current_state.offset_x * actor.movement.facing_direction
	actor.doll.offset.y = current_state.offset_y
	current_state.on_enter()
