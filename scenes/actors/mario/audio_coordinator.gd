class_name AudioCoordinator
extends AudioStreamPlayer
# A method of coordination between a player's sound effects


var should_play : bool # Check if the audio coordinator should play a sound

var last_played_sfx : AudioStream # The last sound effect that was played
var sfx_delay_timer : float

var state : State # State that issues the player


func _process(delta):
	sfx_delay_timer = max(sfx_delay_timer - delta, 0)

	if sfx_delay_timer == 0 and should_play:
		should_play = false

		load_sfx(state.get_sfx())
		play()

func load_sfx(sfx_array : Array): # Ready the sound effect
	var sfx : AudioStream # The sound effect that will play

	sfx = get_rand_sfx(sfx_array)

	if sfx_array.size() > 1:
		while last_played_sfx == sfx:
			sfx = get_rand_sfx(sfx_array)

		last_played_sfx = sfx

	stream = sfx


func play_sfx(new_state : State, sfx_sfx_delay : float = 0):
	sfx_delay_timer = sfx_sfx_delay
	should_play = true
	state = new_state


func get_rand_sfx(sfx_array : Array) -> AudioStream: # Get a random sfx from the state's sounds array
	return sfx_array[randi_range(0, sfx_array.size() - 1)]
