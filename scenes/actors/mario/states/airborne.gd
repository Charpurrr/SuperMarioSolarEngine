class_name AirborneState
extends State
# A base state for all airborne states


@onready var substates : Dictionary = {
	groundpound_fall = $GroundPound/GroundPoundFall,
	groundpound = $GroundPound,
	sideflip = $Sideflip,
	backflip = $Backflip,
	freefall = $FreeFall,
	jump = $Jump,
	fall = $Fall,
}


func switch_check():
	if actor.is_on_floor():
		return %Idle

	return null
