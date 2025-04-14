class_name WorldMachine
extends Node2D
## The [WorldMachine] handles area loading and behaviour during gameplay.
## It's a container for the level, the user interface, and the player.
## It's always loaded when a level is being played.

signal level_reloaded

## Whether or not [member level_scene] should be automatically loaded.
@export var autoload: bool = true
@export var level_scene: PackedScene

@export_category("Constant")
@export var user_interface: PackedScene

var level_node: Level
var env_node: LevelEnvironment
var ui_node: UserInterface


func _ready():
	GameState.reload.connect(_reload_level)

	if autoload and level_scene != null:
		var level = level_scene.instantiate()
		load_level(level)


## Stores a level as a scene, so it can be reloaded.
func store_level_scene(level: Level) -> void:
	var scene = PackedScene.new()
	scene.pack(level)
	level_scene = scene


func load_level(level: Level, store: bool = false) -> void:
	if store:
		store_level_scene(level)

	level_node = level

	add_child(level_node)

	# Reinstantiate and configure environment node.
	if level_node.level_environment:
		# If a level environment is already loaded, get rid of it and replace it with the new one.
		if env_node:
			env_node.queue_free()

		env_node = level_node.level_environment.instantiate()
		env_node.camera = level_node.camera

		level_node.add_child(env_node)

	# Reinstantiate and configure UI node.
	if user_interface:
		ui_node = user_interface.instantiate()
		ui_node.world_machine = self

		add_child(ui_node)

	# Set UI's level environment if both itself and the environment exists.
	if level_node.level_environment and user_interface:
		ui_node.level_environment = env_node

	# Assign player to camera if applicable.
	if level_node.camera is PlayerCamera:
		level_node.camera.player = level_node.player

	# Set the appropriate background music.
	MusicManager.music = level_node.level_music

	# Set the camera as current.
	level_node.camera.make_current()


## Called with [GameState]'s reload signal.
func _reload_level():
	var new_level: Node2D = level_scene.instantiate()
	var tree: SceneTree = get_tree()

	# For disabling the pause screen if it was open.
	if tree.paused == true:
		GameState.pause_toggle()

	# Delete the level and UI, then re-add them.
	level_node.queue_free()
	ui_node.queue_free()
	
	# Reset static variables
	Coin.total_reds = 0

	load_level(new_level)

	level_reloaded.emit()
