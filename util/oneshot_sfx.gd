class_name SFX
extends Resource
## Utility class for creating and destroying a singular sound effect
## using a temporary [AudioStreamPlayer].

## Creates an [AudioStreamPlayer], assigns the corresponding data,
## adds it to node, then destroys it when finished.
static func play_sfx(stream: AudioStream, bus: StringName, node: Node) -> void:
	if not node.is_inside_tree() or stream == null:
		return

	# If no bus is specified, simply play to the Master bus.
	if bus.is_empty():
		bus = &"Master"

	var player := AudioStreamPlayer.new()

	player.set_stream(stream)
	player.set_bus(bus)
	player.add_to_group(bus)

	node.add_child(player)

	player.play()
	player.connect(&"finished", player.queue_free)
