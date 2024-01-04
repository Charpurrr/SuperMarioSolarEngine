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
