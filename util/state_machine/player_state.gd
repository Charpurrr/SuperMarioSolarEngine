class_name PlayerState
extends State
## State specialised for player characters.


## The name of the animation that this state should play.
@export var animation := &""
## How many pixels the animation needs to be offset.
@export var anim_offset: Vector2i

## sfx_layers is a list of the possible sound effects that can play at once.
## [br][br]This is useful if you want a state to play more than just one sound on entry.
## [br][br]Every array inside of the sfx_layers array is said list of possible sound effects it can cycle through.
@export var sfx_layers: Array[SFXLayer]
## If the next sound effect should always differ from the previous one or not.
@export var force_new: bool = true

@onready var input: InputManager = null
@onready var movement: PMovement = null

## Returns a float from -1 to 1 indicating the value of the horizontal input axis.
var input_direction: float


func _physics_process(_delta):
	input_direction = InputManager.get_x()


func trigger_enter(handover):
	super(handover)

	if not animation.is_empty():
		actor.doll.play(animation)

	if not sfx_layers.is_empty():
		for sfx_list in sfx_layers:
			play_sfx(sfx_list, force_new)

	actor.doll.offset = anim_offset


## Plays a random sound effect from an array.
func play_sfx(layer: SFXLayer, randomized: bool):
	var player := AudioStreamPlayer.new()

	layer.new_pick = layer.sfx_list.pick_random()

	if randomized and layer.sfx_list.size() > 1:
		while layer.new_pick == layer.last_pick:
			layer.new_pick = layer.sfx_list.pick_random()

	call_deferred("add_child", player)
	player.stream = layer.new_pick
	player.bus = layer.bus
	player.autoplay = true

	player.connect(&"finished", player.queue_free)

	layer.last_pick = layer.new_pick


func trigger_exit():
	super()

	for sfx_list in sfx_layers:
		if sfx_list.cutoff_sfx:
			for child in get_children():
				if child is AudioStreamPlayer:
					child.queue_free()
