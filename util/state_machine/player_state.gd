class_name PlayerState
extends State
# State specialised for player characters.


@onready var input: InputManager = null
@onready var movement: PMovement = null

## Returns a float from -1 to 1 indicating the value of the horizontal input axis.
var input_direction: float


func _physics_process(_delta):
	input_direction = InputManager.get_x()


## Trigger entrance events for a new state.
func trigger_enter(handover: Variant):
	_first_cycle = true
	_on_enter(handover)

	if av != null and effect != &"":
		av.trigger_effect(effect, effect_offset * Vector2i(movement.facing_direction, 1))
