class_name PlayerState
extends State
## State specialised for player characters.


@export_category(&"Animation")
## The name of the animation that this state should play.
@export var animation := &""
## How many pixels the animation needs to be offset.
@export var anim_offset: Vector2i

@export_category(&"Sound")
## If the sound effect(s) should play as soon as the state starts or not.
@export var on_enter: bool = true
## sfx_layers is a list of the possible sound effects that can play at once.
## [br][br]This is useful if you want a state to play more than just one sound on entry.
## [br][br]Every array inside of the sfx_layers array is said list of possible sound effects it can cycle through.
@export var sfx_layers: Array[SFXLayer]
## If the next sound effect should always differ from the previous one or not.
@export var force_new: bool = true

@onready var input: InputManager = null
@onready var movement: PMovement = null


func trigger_enter(handover):
	if not animation.is_empty():
		actor.doll.play(animation)

	actor.doll.offset = anim_offset

	if on_enter and not sfx_layers.is_empty():
		for sfx_list in sfx_layers:
			SFXLayer.play_sfx(self, sfx_list, force_new)

	super(handover)


func trigger_exit():
	super()

	for layer in sfx_layers:
		if not layer.cutoff_sfx:
			continue

		for child in get_children():
			if child is AudioStreamPlayer and child.stream in layer.sfx_list:
				child.queue_free()
