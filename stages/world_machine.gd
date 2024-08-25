class_name WorldMachine
extends Node2D
## The [WorldMachine] handles area loading and behaviour during gameplay.
## It's a container for the level, the user interface, and the player.
## It's always loaded when a level is being played.

signal level_reloaded

@export var loaded_level: PackedScene

@export var level_name: StringName
@export var mission_name: StringName
@export_multiline var mission_info: String

@export var loaded_environment: PackedScene

@export_category(&"References")
@export var user_interface: PackedScene

var level_node: Node2D
var env_node: LevelEnvironment
var ui_node: UserInterface


func _ready():
	GameState.reload.connect(_reload_level)

	level_node = loaded_level.instantiate()
	env_node = loaded_environment.instantiate()
	ui_node = user_interface.instantiate()

	env_node.camera = level_node.camera
	ui_node.world_machine = self

	# Order of children matters here!
	add_child(level_node)
	level_node.add_child(env_node)

	add_child(ui_node)


## Called with [GameState]'s reload signal.
func _reload_level():
	var new_level: Node2D = loaded_level.instantiate()
	var new_env: LevelEnvironment = loaded_environment.instantiate()

	var tree: SceneTree = get_tree()

	# For disabling the pause screen if it was open
	if tree.paused == true:
		GameState.pause_toggle()

	# Free the level and then re-add it.
	level_node.queue_free()

	level_node = new_level
	new_env.camera = new_level.camera

	add_child(level_node)
	level_node.add_child(new_env)

	level_reloaded.emit()
