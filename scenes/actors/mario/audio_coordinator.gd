class_name AudioCoordinator
extends AudioStreamPlayer
# A method of coordination between a player's sound effects


func play_sfx(sfx_array : Array):
	var last_played_sfx : AudioStream # The last sound effect that was played
	var sfx : AudioStream # The sfx that will play

	last_played_sfx = sfx

	while last_played_sfx == sfx:
		sfx = sfx_array[randi_range(0, sfx_array.size() - 1)]

	print(last_played_sfx)

	stream = sfx
	play()
