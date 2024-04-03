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
@onready var notif_list: Node = $Notifications

var notif_scene: PackedScene = preload("res://scenes/ui/notification/notification.tscn")
var current_notifs: Array = []
#endregion


func _ready():
	bgm_muted = LocalSettings.load_setting("Audio", "Music Muted", false)

	_set_muted_bgm()


func _process(_delta):
	_music_control()
	_advance_frame()
	_resetting()
	_pausing()

	if get_tree().paused == true and Input.is_action_just_pressed(&"frame_advance"):
		can_fa = true

	for i in current_notifs:
		if not is_instance_valid(i):
			current_notifs.erase(i)


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
