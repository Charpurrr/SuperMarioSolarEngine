class_name AirborneState
extends State
# A base state for all airborne states


@onready var substates : Dictionary = {
	groundpound_fall = %GroundPoundFall,
	groundpound = %GroundPound,
	wallslide = %Wallslide,
	walljump = %Walljump,
	sideflip = %Sideflip,
	backflip = %Backflip,
	freefall = %Freefall,
	jump = %Jump,
	fall = %Fall,
}


func switch_check():
	if actor.is_on_floor() and not actor.movement.active_buffer_jump():
		return %Idle

	if Input.is_action_just_pressed("jump") and actor.movement.active_coyote_time():
		return substates.jump

	return null
