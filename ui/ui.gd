class_name UserInterface
extends CanvasLayer
## UI and utility.

@export_category(&"Pause Variables")
@export var screen_manager: ScreenManager
@export var color_blur: ColorRect
@export var game_pause_sfx: AudioStream
@export var game_unpause_sfx: AudioStream

@export_category(&"Camera Variables")
@export var zoom_blur_player: AnimationPlayer

@export_category(&"Notification Variables")
@export var notif_scene: PackedScene

@export var notif_list: Node

var current_notifs: Array = []

@export_category(&"Debug Variables")
@export var debug_label: Label
@export var commit_labl: Label
@export var input_display: Control

@onready var input_display_sprites: Dictionary = {
	KEY_SHIFT: %Shift,
	KEY_W: %W,
	KEY_X: %X,
	KEY_C: %C,
	KEY_UP: %Up,
	KEY_RIGHT: %Right,
	KEY_DOWN: %Down,
	KEY_LEFT: %Left,
}

## This variable is set in [code]world_machine.tscn[/code].
var world_machine: WorldMachine
## See [code]_set_player()[/code].
var player: CharacterBody2D
## See [code]_set_camera()[/code].
var camera: PlayerCamera


func _ready():
	_toggle_debug()
	_set_player()
	_set_camera()

	world_machine.level_reloaded.connect(_set_player)
	GameState.debug_toggled.connect(_toggle_debug)


func _process(_delta):
	color_blur.visible = GameState.is_paused()

	for i in current_notifs:
		if not is_instance_valid(i):
			current_notifs.erase(i)


func _input(event: InputEvent):
	if (
		(event.is_action_pressed(&"camera_zoom_in") and camera.target_zoom != camera.zoom_min) or
		(event.is_action_pressed(&"camera_zoom_out") and camera.target_zoom != camera.zoom_max)
	):
		zoom_blur_player.play(&"camera_focus")

	if event.is_action_pressed(&"pause"):
		_pause_logic()

	_display_input(event)


func _pause_logic():
	# Ignore the pause input if a screen is being transitioned to/from.
	if screen_manager.anime_player.is_playing():
		return

	if not GameState.is_paused():
		SFX.play_sfx(game_pause_sfx, &"UI", screen_manager)

		screen_manager.switch_screen(null, screen_manager.pause_screen)
		GameState.emit_signal(&"paused")
	elif screen_manager.current_screen is PauseScreen:
		SFX.play_sfx(game_unpause_sfx, &"UI", screen_manager)
		screen_manager.switch_screen(screen_manager.pause_screen, null)
		GameState.emit_signal(&"paused")
	else:
		screen_manager.switch_screen(screen_manager.current_screen, screen_manager.pause_screen)


## Creates a visual "notification" type indicator on the screen.
func _push_notif(type: StringName, input: String):
	var notif: Control = notif_scene.instantiate()

	notif.type = type
	notif.input = input

	if current_notifs != []:
		for i in current_notifs:
			if is_instance_valid(i):
				i.position.y -= 35

	current_notifs.append(notif)

	notif_list.add_child(notif)


func _display_input(event: InputEvent):
	if not event is InputEventKey:
		return

	var event_str: Key = event.keycode

	if not input_display_sprites.has(event_str):
		return

	var texture: TextureRect = input_display_sprites[event_str]

	if event.is_pressed():
		texture.set_modulate(Color(1, 1, 1, 1))
	else:
		texture.set_modulate(Color(1, 1, 1, 0.5))


func _toggle_debug():
	var toggle: bool = GameState.debug_toggle
	input_display.visible = toggle
	commit_labl.visible = toggle
	debug_label.visible = toggle


func _set_player():
	player = world_machine.level_node.player


func _set_camera():
	camera = world_machine.level_node.camera
