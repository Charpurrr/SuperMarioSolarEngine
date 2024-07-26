class_name WorldMachine
extends Node2D
## The [WorldMachine] handles area loading and behaviour during gameplay.
## It's a container for the level, the user interface, and the player.
## It's always loaded when a level is being played.

signal level_reloaded

@export var loaded_level: PackedScene
@export var loaded_environment: PackedScene

@export_category(&"References")
@export var user_interface: PackedScene

var level_node: Node2D
var env_node: LevelEnvironment


func _ready():
	GameState.reload.connect(_reload_level)

	level_node = loaded_level.instantiate()
	env_node = loaded_environment.instantiate()

	env_node.camera = level_node.camera

	# Order of children matters here!
	add_child(level_node)
	level_node.add_child(env_node)
	add_child(user_interface.instantiate())


## Called with [GameState]'s reload signal.
func _reload_level():
	var new_level: Node2D = loaded_level.instantiate()
	var tree: SceneTree = get_tree()

	# For disabling the pause screen if it was open
	if tree.paused == true:
		GameState.pause_toggle()

	# Free the level and then re-add it.
	level_node.queue_free()
	level_node = new_level
	add_child(level_node)

	emit_signal("level_reloaded")
