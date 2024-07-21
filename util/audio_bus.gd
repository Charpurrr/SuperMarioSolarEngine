class_name AudioBus
extends RefCounted

var bus_name: StringName  # I.e. &"Master"
var setting_name: String  # I.e. "master_volume"

var bus_index: int

var percentage: Label
var reset: Button

var default_db: float

var current_vol_linear: float


func _init(new_bus_name: StringName, new_setting_name: String):
	setting_name = new_setting_name
	bus_name = new_bus_name

	var saved_linear: float = LocalSettings.load_setting("Audio", setting_name, 1.0)

	bus_index = AudioServer.get_bus_index(bus_name)

	default_db = AudioServer.get_bus_volume_db(bus_index)

	update_volume(saved_linear)


func update_volume(new_vol_linear: float):
	current_vol_linear = new_vol_linear

	var db = linear_to_db(new_vol_linear)

	AudioServer.set_bus_volume_db(bus_index, db + default_db)

	LocalSettings.change_setting("Audio", setting_name, new_vol_linear)
