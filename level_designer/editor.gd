class_name LevelEditor
extends Node
## Base class for the level editor.

@export var user_interface: CanvasLayer
@export var quit_confirm: ConfirmationDialog
@export var selection_box: NinePatchRect
@export var level: LevelPreview
@export var camera: Camera2D
@export var world_machine: WorldMachine


func _ready():
	get_tree().set_auto_accept_quit(false)


func _on_play_button_pressed() -> void:
	var created_level = Level.new()
	for preview in level.get_children():
		preview = preview as PreviewItem
		var data = preview.item_data
		if data is EditorItemActor:
			var inst = data.item_scene.instantiate()
			for property in data.properties:
				var prop_name = property.name
				assert(prop_name in inst)
				inst.set(prop_name, preview.property_values[prop_name])
			inst.position = preview.position
			created_level.add_child(inst)

	var mario = preload("res://entities/player/mario/mario.tscn").instantiate()
	created_level.add_child(mario)
	created_level.player = mario
	var cam = Camera2D.new()
	mario.add_child(cam)
	created_level.camera = cam
	cam.enabled = true
	world_machine.handle_level_node(created_level, true)
