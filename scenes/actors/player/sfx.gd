class_name SFXLayer
extends Resource

## List of possible sound effect(s) this layer can iterate through.
@export var sfx_list: Array
## What audio bus this layer should play its sound effect(s) to.
@export var bus: StringName

## If changing the state should end the sound effect(s) early.
@export var cutoff_sfx: bool = true

var last_pick: AudioStream
var new_pick: AudioStream


## Plays a sound effect from an array.
static func play_sfx(node: Object, layer: SFXLayer, randomized: bool):
	var player := AudioStreamPlayer.new()

	layer.new_pick = layer.sfx_list.pick_random()

	if randomized and layer.sfx_list.size() > 1:
		while layer.new_pick == layer.last_pick:
			layer.new_pick = layer.sfx_list.pick_random()

	node.call_deferred("add_child", player)
	player.stream = layer.new_pick
	player.bus = layer.bus
	player.autoplay = true

	player.connect(&"finished", player.queue_free)

	layer.last_pick = layer.new_pick
