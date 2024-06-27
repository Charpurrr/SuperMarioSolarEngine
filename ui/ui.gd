class_name UserInterface
extends CanvasLayer
## UI and utility.

#region Notification variables
@export var notif_scene: PackedScene

@export var notif_list: Node

var current_notifs: Array = []
#endregion

#region Input Display variables
@onready var sprite_dictionary: Dictionary = {
	KEY_SHIFT: %Shift,
	KEY_Z: %Z,
	KEY_X: %X,
	KEY_C: %C,
	KEY_UP: %Up,
	KEY_RIGHT: %Right,
	KEY_DOWN: %Down,
	KEY_LEFT: %Left,
}

@export var pause_menu: Control

var input_event: InputEvent
#endregion


func _ready():
	GameState.connect(&"frame_advanced", _push_notif.bind(&"push", "Advanced 1 frame."))
	GameState.connect(&"paused", pause_menu.enable_disable)


func _process(_delta):
	for i in current_notifs:
		if not is_instance_valid(i):
			current_notifs.erase(i)


func _input(event: InputEvent):
	input_event = event

	_display_input(input_event)


## Creates a visual "notification" type indicator on the screen.
func _push_notif(type: StringName, input: String):
	var notif: Node = notif_scene.instantiate()

	notif.type = type
	notif.input = input

	if current_notifs != []:
		for i in current_notifs:
			if is_instance_valid(i):
				i.position.y -= 80

	current_notifs.append(notif)

	notif_list.add_child(notif)


func _display_input(event: InputEvent):
	if not event is InputEventKey:
		return

	var event_str: Key = event.keycode

	if not sprite_dictionary.has(event_str):
		return

	var texture: TextureRect = sprite_dictionary[event_str]

	if event.is_pressed():
		texture.set_modulate(Color(1, 1, 1, 1))
	else:
		texture.set_modulate(Color(1, 1, 1, 0.5))
