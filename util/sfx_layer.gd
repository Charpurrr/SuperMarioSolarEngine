class_name SFXLayer
extends Resource

## List of possible sound effect(s) this layer can iterate through.
@export var sfx_list: Array
## What audio bus this layer should play its sound effect(s) to.
@export var bus: StringName

## How many seconds pass before the sound effect(s) play.
@export var delay_time: float = 0.0
## Whether or not a sound effect can play more than once in a row.
@export var force_new: bool = false
## Whether or not changing the state should end the sound effect(s) early.
@export var cutoff_sfx: bool = true
## Whether or not playing these sound effect(s) should end
## all the other sound effects in the same AudioBus.
@export var overwrite_other: bool = true

var last_pick: AudioStream
var new_pick: AudioStream


## Plays a sound effect from the list at a specific node.
func play_sfx_at(node: Node):
	var timer: SceneTreeTimer = node.get_tree().create_timer(delay_time)

	if delay_time != 0:
		await timer.timeout

	if node == null:
		return

	new_pick = sfx_list.pick_random()

	if force_new and sfx_list.size() > 1:
		while new_pick == last_pick:
			new_pick = sfx_list.pick_random()

	if overwrite_other:
		node.get_tree().call_group(bus, &"queue_free")

	SFX.play_sfx(new_pick, bus, node)

	last_pick = new_pick
