extends VBoxContainer

@export var user_interface: UserInterface

@export var level_name: Label
@export var mission_name: Label
@export var mission_info: Label


func _ready():
	var level: Level = user_interface.world_machine.level_node

	level_name.text = level.level_name
	mission_name.text = level.mission_name
	mission_info.text = level.mission_info
