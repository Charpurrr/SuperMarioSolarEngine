class_name OdysseyDive
extends Dive
## Diving after a groundpound.


func _tell_switch():
	if actor.is_on_floor():
		return &"DiveSlide"

	return &""
