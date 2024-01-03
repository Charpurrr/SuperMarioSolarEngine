class_name PlayerState
extends State
## State specialised for player characters.


## The name of the animation that this state should play.
@export var animation := &""
## How many pixels the animation needs to be offset.
@export var anim_offset: Vector2i
## Soundeffect(s) this state should play when entered.
@export var sfx: Array
## If the sound effect(s) should get cut off when entering a different state or not.
@export var cutoff_sfx: bool = true

@onready var input: InputManager = null
@onready var movement: PMovement = null

## Returns a float from -1 to 1 indicating the value of the horizontal input axis.
var input_direction: float

## Last picked sound effect to play.
var last_pick: AudioStream
## Newly picked sound effect to play.
var new_pick: AudioStream


func _physics_process(_delta):
	input_direction = InputManager.get_x()


func trigger_enter(handover):
	super(handover)

	if not animation.is_empty():
		actor.doll.play(animation)

	if not sfx.is_empty():
		play_rnd_sfx(sfx)

	actor.doll.offset = anim_offset


## Plays a random sound effect from an array.
func play_rnd_sfx(array: Array):
	var player := AudioStreamPlayer.new()

	if array.size() > 1:
		while new_pick == last_pick:
			new_pick = array.pick_random()
	else:
		new_pick = array.pick_random()

	call_deferred("add_child", player)
	player.stream = new_pick
	player.autoplay = true

	last_pick = new_pick


func _on_exit():
	super()

	for child in get_children():
		if child is AudioStreamPlayer:
			if cutoff_sfx or child.finished:
				queue_free()
