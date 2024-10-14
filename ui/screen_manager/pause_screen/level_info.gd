extends VBoxContainer

@export var user_interface: UserInterface

@export var level_name: Label
@export var mission_name: Label
@export var mission_info: Label


func _ready():
	var world_machine: WorldMachine = user_interface.world_machine

	level_name.text = world_machine.level_name
	mission_name.text = world_machine.mission_name
	mission_info.text = world_machine.mission_info
