class_name UserInterface
extends CanvasLayer
## UI and utility.

# temporary for debug label
@onready var player: CharacterBody2D = get_parent().find_child("Mario")

var bgm_muted: bool = false

const FRAME_TIME: int = 2
var frame_timer: int

## Whether or not you can advance a frame.
var can_fa: bool = false

#region Notification variables
@export var notif_scene: PackedScene

@onready var notif_list: Node = $Notifications

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

var input_event: InputEvent
#endregion


func _ready():
	bgm_muted = LocalSettings.load_setting("Audio", "Music Muted", false)

	_set_muted_bgm()


func _process(_delta):
	_music_control()
	_advance_frame()
	_resetting()
	_pausing()

	if is_inside_tree() and get_tree().paused and Input.is_action_just_pressed(&"frame_advance"):
		can_fa = true

	for i in current_notifs:
		if not is_instance_valid(i):
			current_notifs.erase(i)


func _input(event: InputEvent):
	input_event = event

	_display_input(input_event)


## Frame advancing only works while paused.
func _advance_frame():
	if not can_fa:
		frame_timer = FRAME_TIME
		return

	get_tree().paused = false
	frame_timer = max(frame_timer - 1, 0)

	if frame_timer == 0:
		_push_notif(&"push", "Advanced 1 frame.")

		get_tree().paused = true
		can_fa = false


func _pausing():
	if Input.is_action_just_pressed(&"pause"):
		get_tree().paused = !get_tree().paused


func _music_control():
	if Input.is_action_just_pressed(&"mute"):
		bgm_muted = !bgm_muted

		LocalSettings.change_setting("Audio", "Music Muted", bgm_muted)
		_set_muted_bgm()


func _set_muted_bgm():
	AudioServer.set_bus_mute(AudioServer.get_bus_index("BGM"), bgm_muted)


func _resetting():
	if Input.is_action_just_pressed(&"reset"):
		get_tree().reload_current_scene()


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

	var sprite: Sprite2D = sprite_dictionary[event_str]

	if event.is_pressed():
		sprite.set_modulate(Color(1, 1, 1, 1))
	else:
		sprite.set_modulate(Color(1, 1, 1, 0.5))
