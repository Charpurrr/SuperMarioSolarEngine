class_name AirborneState
extends State
# A base state for all airborne states


@onready var substates : Dictionary = {
	sideflip = %Sideflip,
	backflip = %Backflip,
	jump = %Jump,
	fall = %Fall,
}


func switch_check():
	if actor.is_on_floor():
		return %Idle

	return null
