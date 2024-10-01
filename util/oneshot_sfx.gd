class_name SFX
extends Resource
## Utility class for creating and destroying a singular sound effect
## using a temporary [AudioStreamPlayer].

## Creates an [AudioStreamPlayer], assigns the corresponding data,
## adds it to node, then destroys it when finished.
static func play_sfx(stream: AudioStream, bus: StringName, node: Node) -> void:
	var player := AudioStreamPlayer.new()

	player.set_stream(stream)
	player.set_bus(bus)
	player.add_to_group(bus)

	node.add_child(player)

	player.play()
	
	player.connect(&"finished", player.queue_free)
