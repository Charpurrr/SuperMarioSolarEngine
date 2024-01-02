class_name OdysseyDive
extends AirDive
## Diving after a groundpound.


func _tell_switch():
	if actor.is_on_floor():
		return &"DiveSlide"

	return &""
