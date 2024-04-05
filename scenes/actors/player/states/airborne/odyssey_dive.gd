class_name OdysseyDive
extends Dive
## Diving after a groundpound.


func _trans_rules():
	if actor.is_on_floor():
		return &"DiveSlide"

	return &""
