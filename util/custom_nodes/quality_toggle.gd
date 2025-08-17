class_name QualityToggle
extends Node
## Stops the processing of its parent node when a specified quality is set.

## On what quality (or lower) the parent should stop being processed.
## For example, if [code]Medium[/code] is set as the value, the parent
## will also stop processing on [code]Low[/code] quality.
@export var stop_parent_on: GameState.Qualities = GameState.Qualities.LOW

var stored_mode: Node.ProcessMode
var stored_mat: Material


func _ready() -> void:
	LocalSettings.setting_changed.connect(_setting_changed)
	_toggle_parent()


func _setting_changed(key: String, _value: Variant) -> void:
	if key == "quality":
		_toggle_parent()


func _toggle_parent() -> void:
	var current_quality: GameState.Qualities = GameState.quality
	var parent: Node = get_parent()

	if current_quality <= stop_parent_on:
		stored_mode = parent.process_mode
		parent.process_mode = Node.PROCESS_MODE_DISABLED
		parent.visible = false

		if parent is CanvasItem:
			stored_mat = parent.material
			parent.material = null
	else:
		parent.process_mode = stored_mode
		parent.material = stored_mat
		parent.visible = true
