class_name WorldMachine
extends Node2D
## The [WorldMachine] handles area loading and behaviour during gameplay.
## It's a container for the level, the user interface, and the player.
## It's always loaded when a level is being played.

signal level_reloaded

@export var level_scene: PackedScene

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

	if level_scene != null:
		var level = level_scene.instantiate()
		handle_level_node(level)


func store_level_scene(scene: PackedScene) -> void:
	level_scene = scene


func handle_level_node(level: Level, store: bool = false) -> void:
	if store:
		var scene = PackedScene.new()
		scene.pack(level)

	level_node = level

	if env_node != null:
		env_node.queue_free()
	env_node = loaded_environment.instantiate()

	if ui_node != null:
		ui_node.queue_free()
	ui_node = user_interface.instantiate()

	env_node.camera = level_node.camera
	ui_node.world_machine = self

	# Order of children matters here!
	add_child(level_node)
	level_node.add_child(env_node)

	add_child(ui_node)

	level_node.camera.make_current()


## Called with [GameState]'s reload signal.
func _reload_level():
	var new_level: Node2D = level_scene.instantiate()
	var tree: SceneTree = get_tree()

	# For disabling the pause screen if it was open
	if tree.paused == true:
		GameState.pause_toggle()

	# Free the level and then re-add it.
	level_node.queue_free()

	handle_level_node(new_level)

	level_reloaded.emit()
