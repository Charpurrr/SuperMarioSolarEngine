class_name PlayerState
extends State
## State specialised for player characters.


## The name of the animation that this state should play.
@export var animation := &""
## How many pixels the animation needs to be offset.
@export var anim_offset: Vector2i

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

	actor.doll.offset = anim_offset
