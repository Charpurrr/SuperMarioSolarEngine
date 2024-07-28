class_name UserInterface
extends CanvasLayer
## UI and utility.

@export var pause_screen: Control

#region Notification variables
@export var notif_scene: PackedScene

@export var notif_list: Node

var current_notifs: Array = []
#endregion

#region Input Display variables
@onready var sprite_dictionary: Dictionary = {
	KEY_SHIFT: %Shift,
	KEY_W: %W,
	KEY_X: %X,
	KEY_C: %C,
	KEY_UP: %Up,
	KEY_RIGHT: %Right,
	KEY_DOWN: %Down,
	KEY_LEFT: %Left,
}

var input_event: InputEvent
#endregion

## This variable is set in [code]world_machine.tscn[/code].
var world_machine: WorldMachine

@onready var player: CharacterBody2D


func _ready():
	_set_player()

	GameState.frame_advanced.connect(_push_notif.bind(&"push", "Advanced 1 frame."))
	world_machine.level_reloaded.connect(_set_player)


func _process(_delta):
	if Input.is_action_just_pressed(&"pause"):
		GameState.emit_signal(&"paused")
		pause_screen.enable_disable_screen()
		pause_screen.update_settings_visibility(false)

	for i in current_notifs:
		if not is_instance_valid(i):
			current_notifs.erase(i)


func _input(event: InputEvent):
	input_event = event

	_display_input(input_event)


## Creates a visual "notification" type indicator on the screen.
func _push_notif(type: StringName, input: String):
	var notif: Control = notif_scene.instantiate()

	notif.type = type
	notif.input = input

	if current_notifs != []:
		for i in current_notifs:
			if is_instance_valid(i):
				print(notif.size.y)
				i.position.y -= 35

	current_notifs.append(notif)

	notif_list.add_child(notif)


func _display_input(event: InputEvent):
	if not event is InputEventKey:
		return

	var event_str: Key = event.physical_keycode

	if not sprite_dictionary.has(event_str):
		return

	var texture: TextureRect = sprite_dictionary[event_str]

	if event.is_pressed():
		texture.set_modulate(Color(1, 1, 1, 1))
	else:
		texture.set_modulate(Color(1, 1, 1, 0.5))


func _set_player():
	player = world_machine.level_node.player
